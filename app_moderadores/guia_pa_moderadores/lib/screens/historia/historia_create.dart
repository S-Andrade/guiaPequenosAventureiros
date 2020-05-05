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

  String titulo;
  
  List<Historia> listHistoria;
  var image;

  
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
            appBar: new AppBar(title: new Text("Criar Historia")),
             body:Form(
              key: _formKey,
              child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                     Center(
                      child: Container(
                        width: 600,
                      //  height: 300,
                        padding: const EdgeInsets.only(top: 50),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                        
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Titulo da historia não inserido';
                            }
                          },
                          onSaved: (input) => titulo = input,
                          decoration: new InputDecoration(
                            labelText: "Titulo da historia",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                                  )
                    )
                    ),

                    Center(
                    child: Container(
                    padding: const EdgeInsets.only(left: 300, top: 50, bottom: 50),
                    child: Row(children: <Widget>[
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Builder(
                          builder: (BuildContext context) {
                            if(image != null){
                              return Image(
                                image: FileImage(image),
                                width: 300,
                                height: 300,
                              );
                            }else{
                              return Icon(Icons.image);
                            }
                          }
                        ),
                      ),
                       GestureDetector(  
                                                         
                                onTap: () {
                                 getImage(context);
                                },
                                child: Container(
                                  width: 300,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                        )
                                      ]),
                                  child: Center(
                                      child: Text(
                                    'Imagem',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              ),
                    ]))),
                          
                          GestureDetector(
                                onTap: () {
                                  print('create');
                                  certificar(context);
                                },
                                child: Container(
                                  width: 300,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
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
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              )
                ]
            )
             )
          ));
            }); 
        }
       ));
  }

  Future getImage(BuildContext context) async {
    var a = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
          image = a;
    });
    //_formKey.currentState.save();
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

          
      DatabaseService().updateHistoriaData(id_historia, titulo, [], image_path);
      print("crei uma historia");

    }else{
      showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Imagem"),
                content: new Text("Tem de inserir uma imagem!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
    }



  //back to homepage
  Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraCreate()));



  }

  Future<void> certificar(BuildContext context) async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      await getListHistorias(context);
      print(listHistoria);

      bool cert = true;
      if (listHistoria != null){
        
          for (Historia h in listHistoria){
            if(h.titulo == titulo){
              cert=false;
            }
          }

          if (cert){
            create(context);
          }else{
            showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Historia"),
                content: new Text("Historia já!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          }  
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