import 'dart:async';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo_details.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:feature_missoes_moderador/models/activity.dart';
import 'dart:io';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateActivityMissionScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;

  CreateActivityMissionScreen(this.capitulo, this.aventuraId);

  @override
  _CreateActivityMissionScreenState createState() =>
      _CreateActivityMissionScreenState(this.capitulo, this.aventuraId);
}

class _CreateActivityMissionScreenState
    extends State<CreateActivityMissionScreen> {
  _CreateActivityMissionScreenState(this.capitulo, this.aventuraId);

  Aventura aventuraId;
  Capitulo capitulo;
  String _titulo;
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();
  final _text2 = TextEditingController();
  String _pontos;
  final _textPontos = TextEditingController();
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
    activities = [];
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/act.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 0.0, bottom: 15.0),
                            child: Text(
                              "Criar uma atividade",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Text(
                              "Nesta secção, poderão ser criadas as instruções para a realização de uma atividade.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          FlatButton(
                            color: parseColor("F4F19C"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 30.0, bottom: 30.0),
                  child: Column(
                    children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  "Título",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 20),
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
                                  color: parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  controller: _text,
                                  onChanged: (value) {
                                    _titulo = value;
                                  },
                                  maxLength: 40,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15),
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
                      SizedBox(height: 20.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  "Pontos",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 20),
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
                                  color: parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  controller: _textPontos,
                                  onChanged: (value) {
                                    _pontos = value;
                                  },
                                  maxLength: 5,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 14),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText:
                                        "Insira os pontos que esta missão vale",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.0),
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
                                height: 200,
                                width: 450,
                                child: ListView(
                                  children:
                                      List.generate(activities.length, (index) {
                                    return Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon:
                                                  Icon(FontAwesomeIcons.check),
                                              iconSize: 15,
                                              color: Colors.blue,
                                              onPressed: null,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 200,
                                                  child: Row(children: [
                                                    Flexible(
                                                      child: Text(
                                                        activities[index]
                                                            .description,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Monteserrat',
                                                            letterSpacing: 2,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                            new Builder(
                                                builder: (BuildContext) =>
                                                    (activities[index]
                                                                .linkImage !=
                                                            null)
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
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          )
                                                        : Container()),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: IconButton(
                                                icon: Icon(
                                                    FontAwesomeIcons.trash),
                                                iconSize: 20,
                                                color: Colors.red,
                                                onPressed: () {
                                                  setState(() {
                                                    activities.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }),
                                ),
                              ),
                              Container(
                                  child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      width: 300,
                                      height: 1,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 140, top: 10, bottom: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adicione aqui cada instrução: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Monteserrat',
                                              color: Colors.black,
                                              letterSpacing: 2),
                                        )
                                      ]),
                                ),
                                Row(children: [
                                  Container(
                                    height: 100,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 150,
                                            width: 200,
                                            child: TextField(
                                              controller: _text2,
                                              onChanged: (value) {
                                                _description = value;
                                              },
                                              maxLength: 170,
                                              maxLengthEnforced: true,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Monteserrat',
                                                  letterSpacing: 2,
                                                  fontSize: 13),
                                              maxLines: 7,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.blue[50],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                hintText: "Descrição",
                                                fillColor: Colors.blue[50],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            child: MaterialButton(
                                              height: 40,
                                              minWidth: 50,
                                              color: parseColor("#FFCE02"),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0)),
                                              child: Text(
                                                'Escolher imagem',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Monteserrat',
                                                    color: Colors.black,
                                                    letterSpacing: 2),
                                              ),
                                              onPressed: getImage,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 10.0),
                                          child: new Builder(
                                              builder: (BuildContext) => _loaded
                                                  ? new Icon(
                                                      FontAwesomeIcons
                                                          .checkCircle,
                                                      color: Colors.green,
                                                      size: 20.0,
                                                    )
                                                  : Container()),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.plusCircle,
                                              color: parseColor("#FFCE02")),
                                          onPressed: () async {
                                            if (_imageFile != null &&
                                                _description != null) {
                                              String link =
                                                  await uploadImageToFirebaseStorage(
                                                      _imageFile);

                                              Activity a = new Activity(
                                                  "", _description, link);

                                              setState(() {
                                                activities.add(a);
                                                _imageFile = null;
                                                _loaded = false;
                                                _text2.clear();
                                              });
                                            } else if (_description != null &&
                                                _imageFile == null) {
                                              Activity a = new Activity(
                                                  "", _description);

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
                                                      fontFamily: 'Monteserrat',
                                                      letterSpacing: 2,
                                                      fontSize: 20),
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
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
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
                              ]))
                            ]),
                          )),
                      SizedBox(
                        height: 10.0,
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
                            color: const Color(0xff72d8bf),
                            onPressed: () async {
                              if (_text.text.length > 0 &&
                                  activities.length != 0 &&
                                  _textPontos.text.length > 0)
                                showConfirmar(context, _titulo, activities,
                                    int.parse(_pontos));
                              else
                                await showError();
                            },
                            child: Text(
                              "Submeter missão",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
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

  showError() async {
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Falta inserir um título ou criar, pelo menos, uma atividade!",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
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

  showConfirmar(BuildContext context, String titulo, List<Activity> activities,
      int pontos) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => MyTemplateConfirmation(options),
    );

    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
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
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        createMissionActivityInFirestore(
            titulo, activities, aventuraId.id, capitulo.id, pontos);
        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CapituloDetails(
                                    capitulo: capitulo, aventura: aventuraId)));
      },
    );

    popup.show(
      close: Container(),
      title: Text(
        "",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "\nTem a certeza que pretende submeter?",
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
  }
}
