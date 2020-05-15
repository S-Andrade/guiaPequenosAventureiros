import 'dart:async';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:feature_missoes_moderador/models/activity.dart';
import 'dart:io';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateActivityMissionScreen extends StatefulWidget {
  
  Aventura aventuraId;
  Capitulo capitulo;

  CreateActivityMissionScreen(this.capitulo,this.aventuraId);

  @override
  _CreateActivityMissionScreenState createState() =>
      _CreateActivityMissionScreenState(this.capitulo,this.aventuraId);
}

class _CreateActivityMissionScreenState
    extends State<CreateActivityMissionScreen> {
  _CreateActivityMissionScreenState(this.capitulo,this.aventuraId);


  Aventura aventuraId;
  Capitulo capitulo;
  String _titulo;
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();
  final _text2 = TextEditingController();

  List<Activity> activities;
  NetworkImage _image;
  File _imageFile;
  var image;
  String _description;
  bool _imageExists;
  bool _loaded;

  Future getImage() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (image != null)
      setState(() {
        _imageFile = image;
        
        _loaded = true;
      });
  }

  @override
  void initState() {
    super.initState();
    activities=[];
    _imageExists = false;
    _loaded = false;
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height,
                  color: parseColor("#320a5c"),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Criar uma atividade",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Nesta secção, poderão ser criadas as instruções para a realização de uma atividade.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          FlatButton(
                            color: Colors.purple[100],
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 2,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 100.0, left: 70.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 100.0,
                                child: Text(
                                  "Título",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 2,
                                      fontSize: 30),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.purple[50],
                                ),
                                child: TextField(
                                  controller: _text,
                                  onChanged: (value) {
                                    _titulo = value;
                                  },
                                  maxLength: 50,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Insira o título",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 50.0),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: parseColor("#320a5c"),
                                    blurRadius: 10.0,
                                  )
                                ]),
                            child: Column(children: [
                              Container(
                                height: 300,
                                width: 700,
                                child:ListView(
                                  children:
                                      List.generate(activities.length, (index) { 
                                    return Column(children: [
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.star),
                                            iconSize: 10,
                                            color: parseColor("#320a5c"),
                                            onPressed: null,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                width: 170,
                                                child: Row(children: [
                                                  Flexible(
                                                    child: Text(
                                                      activities[index]
                                                          .description,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontFamily:
                                                              'Amatic SC',
                                                          letterSpacing: 2,
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ])),
                                          ),
                                          new Builder(
                                              builder: (BuildContext) =>
                                                  (activities[index].linkImage!=null)
                                                      ? Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  activities[
                                                                          index]
                                                                      .linkImage),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        )
                                                      : Container()),
                                          IconButton(
                                            icon: Icon(FontAwesomeIcons.trash),
                                            iconSize: 10,
                                            color: parseColor("#320a5c"),
                                            onPressed: () {
                                              setState(() {
                                                activities.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ]);
                                  }),
                                ),
                              ),
                              Container(
                                child: Row(children: [
                                  Container(
                                    height: 100,
                                    width: 600,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 150,
                                          width: 200,
                                          child: TextField(
                                            controller: _text2,
                                            onChanged: (value) {
                                              _description = value;
                                            },
                                            maxLength: 200,
                                            maxLengthEnforced: true,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Amatic SC',
                                                letterSpacing: 4,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 30),
                                            maxLines: 7,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blue[50],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              hintText: "Descrição",
                                              fillColor: Colors.blue[50],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: MaterialButton(
                                            height: 50,
                                            minWidth: 70,
                                            color: parseColor('#320a5c'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0)),
                                            child: Text(
                                              'Escolher imagem',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: 'Amatic SC',
                                                  color: Colors.white,
                                                  letterSpacing: 4),
                                            ),
                                            onPressed: getImage,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: new Builder(
                                              builder: (BuildContext) => _loaded
                                                  ? new Icon(
                                                      FontAwesomeIcons
                                                          .checkCircle,
                                                      color: Colors.green,
                                                      size: 30.0,
                                                    )
                                                  : Container()),
                                        ),
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.plus),
                                          onPressed: () async {
                                            if (_imageFile != null &&
                                                _description != null) {
                                                
                                              String link =
                                                  await uploadImageToFirebaseStorage(
                                                      _imageFile);

                                              Activity a = new Activity(
                                                  "",_description,link);

                                              setState(() {
                                                activities.add(a);
                                                _imageFile=null;
                                                _loaded = false;
                                                _text2.clear();
                                              });
                                            } else if (_description != null && _imageFile==null) {
                                            
                                              Activity a = new Activity(
                                                  "",_description);

                                              setState(() {
                                                activities.add(a);
                                                _text2.clear();
                                              });
                                            } else {
                                              AlertDialog alerta = AlertDialog(
                                                title: Text(
                                                  "Insira, pelo menos, uma descrição!",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontFamily: 'Amatic SC',
                                                      letterSpacing: 2,
                                                      fontSize: 30),
                                                ),
                                              );

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return alerta;
                                                },
                                              );
                                              Timer(Duration(seconds: 2), () {
                                                Navigator.of(context, rootNavigator: true).pop();
                                              });
                                            }
                                          },
                                          iconSize: 40,
                                          color: parseColor("#320a5c"),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                              )
                            ]),
                          )),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: Colors.purple[100],
                            onPressed: () async {
                       
                              if (_text.text.length > 0 && activities.length!=0)
                                showConfirmar(context, _titulo, activities);
                              else
                                await showError();
                            },
                            child: Text(
                              "Submeter missão",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 2,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showError() async{
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Falta inserir um título ou criar, pelo menos, uma atividade!",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
    );

    // exibe o dialog
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(
      BuildContext context, String titulo, List<Activity> activities) {
    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continuaButton = FlatButton(
      child: Text(
        "Sim",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      onPressed: () {
        createMissionActivityInFirestore(titulo, activities,aventuraId.id,capitulo.id);
        Navigator.of(context,rootNavigator:true).push(
            MaterialPageRoute(builder: (_) => TabBarMissions(capitulo:capitulo,aventura:aventuraId)));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmação",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "Tem a certeza que pretende submeter?",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );

    //exibe o diálogo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
