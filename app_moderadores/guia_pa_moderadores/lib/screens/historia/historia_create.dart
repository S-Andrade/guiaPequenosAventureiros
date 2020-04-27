import 'package:flutter/material.dart';
import 'package:guia_pa_moderadores/screens/aventura/aventura_create.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import 'historia.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;



class HistoriaCreate extends StatefulWidget {

  @override
  _HistoriaCreate createState() => _HistoriaCreate();
}

class _HistoriaCreate extends State<HistoriaCreate> {
  
  final _formKey = GlobalKey<FormState>();

  final myControllerTitulo = TextEditingController();
  
  List<Historia> listHistoria;
   var image;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitulo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider<List<Historia>>.value(value: DatabaseService().historia),
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
                        controller: myControllerTitulo,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Titulo da historia não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Titulo da historia   '
                          )),
                          RaisedButton(
                                child: Text('IMAGEM'),
                                onPressed: getImage,
                              ),
                          GestureDetector(
                                onTap: () {
                                  print('create');
                                  certificar(context);
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
    if (image != null){
      List ids_h = [];
      for (Historia h in listHistoria){
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

          
      DatabaseService().updateHistoriaData(id_historia, myControllerTitulo.text, [], image_path);
      print("crei uma historia");

    }else{
      print("prencher todos os campos");
    }



  //back to homepage
  Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraCreate()));



  }

  Future<void> certificar(BuildContext context) async{
    await getListHistorias(context);
    print(listHistoria);

    bool cert = true;
    if (listHistoria != null){
      if(myControllerTitulo.text != null){
        for (Historia h in listHistoria){
          if(h.titulo == myControllerTitulo.text){
            cert=false;
          }
        }

        if (cert){
        create(context);
        }else{
          print("Historia já existe");
        }
      
      }else{
        print("no titulo");
      }
     
    }

  }

  Future<void> getLists(BuildContext context) async{
    await getListHistorias(context);
    print(listHistoria);
    
  }
  Future<void> getListHistorias(BuildContext context) async{
    listHistoria = Provider.of<List<Historia>>(context, listen: false);
  }
    

}