import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guia_pa_moderadores/screens/home_screen.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import '../historia/historia.dart';
import 'aventura.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;






class AventuraCreate extends StatefulWidget {
  final FirebaseUser user;
  AventuraCreate({this.user});


  @override
  _AventuraCreate createState() => _AventuraCreate(user:user);
}

class _AventuraCreate extends State<AventuraCreate> {

   final FirebaseUser user;
  _AventuraCreate({this.user});

  
  final _formKey = GlobalKey<FormState>();

  final myControllerNome = TextEditingController();
  final myControllerHistoria = TextEditingController();
  final myControllerLocal = TextEditingController();

  List<Historia> listHistorias;
  List<Aventura> listAventura;
  var image;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerNome.dispose();
    myControllerHistoria.dispose();
    myControllerLocal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider<List<Historia>>.value(value: DatabaseService().historia),
        StreamProvider<List<Aventura>>.value(value: DatabaseService().aventura)
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getLists(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
             body:Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                      TextFormField(
                        controller: myControllerNome,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da aventura não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Nome da Aventura   '
                          )),
                      TextFormField(
                        controller: myControllerLocal,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Local não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Local   '
                          )),
                      TextFormField(
                        controller: myControllerHistoria,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da historia não inserido';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Nome da historia   '
                          )),
                         
                              RaisedButton(
                                child: Text('IMAGEM'),
                                onPressed: getImage,
                              ),
                          
                          GestureDetector(
                                onTap: () {
                                  print('create');
                                  create(context);
                                },
                                child: Container(
                                  width: 460,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                        )
                                      ]),
                                  child: Center(
                                      child: Text(
                                    'Criar',
                                    style: TextStyle(
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              )
                ]
            )
            
          ));
            }); 
        }
       ));
  }

  Future getImage() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    print(image);
  }

  Future<void> create(BuildContext context) async {

    print("Entrei!!");

    await getListAventura(context);
    print(listAventura);
    await getListHiostoria(context);
    print(listHistorias);

    
    //create Historia
    if (listHistorias != null && listAventura !=null){
      if (image != null){
        List ids_h = [];
      for (Historia h in listHistorias){
        ids_h.add(int.parse(h.id));
      }
      ids_h.sort();
      var id_historia = (ids_h.last + 1).toString();
      print(id_historia);
      
      var fileExtension = path.extension(image.path);

      var uuid = Uuid().v4();

      var image_path = 'capas/$uuid$fileExtension';
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(image_path);

      await firebaseStorageRef
          .putFile(image)
          .onComplete
          .catchError((onError) {
        print(onError);
        return false;
      });

            
      DatabaseService().updateHistoriaData(id_historia, myControllerHistoria.text, [], image_path);
      print("crei uma historia");

      //create AVENTURA
      List ids_a = [];
        for(Aventura a in listAventura){
          ids_a.add(int.parse(a.id));
        }
        ids_a.sort();
        var id_aventura = (ids_a.last + 1).toString();
        DatabaseService().updateAventuraData(id_aventura, id_historia, Timestamp.now(), myControllerLocal.text,[], user.email, myControllerNome.text);
        print("Criei uma Aventura!");

      //back to homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)));
      }
      else{
        print("no image!!");
      }

    }
    
  }

    

    Future<void> getLists(BuildContext context) async{
      await getListAventura(context);
      print(listAventura);
      await getListHiostoria(context);
      print(listHistorias);  
    }
    Future<void> getListAventura(BuildContext context) async{
      listAventura = Provider.of<List<Aventura>>(context, listen: false);
    }
    Future<void> getListHiostoria(BuildContext context) async{
      listHistorias = Provider.of<List<Historia>>(context, listen: false);
    }

}