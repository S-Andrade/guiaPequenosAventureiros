import 'dart:async';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo_details.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_question_screen.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';
import 'package:provider/provider.dart';

class CreateQuizMissionScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;
  CreateQuizMissionScreen(this.capitulo, this.aventuraId);

  @override
  _CreateQuizMissionScreenState createState() =>
      _CreateQuizMissionScreenState(this.capitulo, this.aventuraId);
}

class _CreateQuizMissionScreenState extends State<CreateQuizMissionScreen> {
  Capitulo capitulo;
  Aventura aventuraId;
  String _titulo;
  List _perguntas = [];
  final _text = TextEditingController();
  final _textPontos = TextEditingController();
  String _pontos;
  MissionsNotifier missionsNotifier;

  _CreateQuizMissionScreenState(this.capitulo, this.aventuraId);

  @override
  void initState() {
    _titulo = "";
    //missionsNotifier = Provider.of<MissionsNotifier>(context, listen: false);
    //_perguntas = getPerguntas(missionsNotifier);
    super.initState();
  }

  getPerguntas(MissionsNotifier missionsNotifier) {
    if (missionsNotifier.currentQuestion != null) {
      if (!_perguntas.contains(missionsNotifier.currentQuestion)) {
        _perguntas.add(missionsNotifier.currentQuestion);
      }
    }
    return _perguntas;
  }

  @override
  Widget build(BuildContext context) {
    print('quiz');
    missionsNotifier = Provider.of<MissionsNotifier>(context);
    _perguntas = getPerguntas(missionsNotifier);
   
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
                      image: AssetImage("assets/images/23.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 85.0, right: 50.0, left: 0.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Criar um Quiz",
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
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Nesta secção, poderão ser criadas as questões para um Quiz que as crianças terão de resolver.",
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
                            height: 60.0,
                          ),
                          FlatButton(
                            color: parseColor("F4F19C"),
                            onPressed: () {
                              setState(() {
                                _perguntas = [];
                                _text.clear();
                                _textPontos.clear();
                                missionsNotifier.currentQuestion = null;
                              });

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
                    padding:
                        EdgeInsets.only(top: 20.0, left: 70.0, bottom: 10.0),
                    child: Column(children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Row(
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
                                  width:
                                      MediaQuery.of(context).size.width / 3.7,
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
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue[50],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Insira o título",
                                      fillColor: Colors.blue[50],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 00.0, left: 0),
                            child: Row(
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
                                  width:
                                      MediaQuery.of(context).size.width / 3.7,
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText:
                                          "Insira os pontos que esta missão vale",
                                      fillColor: Colors.blue[50],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 0.0, top: 10),
                          child: Container(
                              width: 480,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius:
                                          5.0, // has the effect of softening the shadow
                                      spreadRadius:
                                          2.0, // has the effect of extending the shadow
                                      offset: Offset(
                                        0.0, // horizontal
                                        2.5, // vertical
                                      ),
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Column(children: [
                                  Container(
                                      height: 200,
                                      color: Colors.white,
                                      width: 430,
                                      child: ListView.separated(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(
                                                          FontAwesomeIcons
                                                              .check),
                                                      iconSize: 20,
                                                      color: Colors.blue,
                                                      onPressed: null,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                          width: 280,
                                                          child: Row(children: [
                                                            Flexible(
                                                              child: Text(
                                                                _perguntas[
                                                                        index]
                                                                    .question,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'Monteserrat',
                                                                    letterSpacing:
                                                                        2,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ])),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                          FontAwesomeIcons
                                                              .trash),
                                                      iconSize: 20,
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          _perguntas
                                                              .removeAt(index);
                                                          missionsNotifier
                                                                  .currentQuestion =
                                                              null;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]);
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Divider(
                                                height: 70,
                                                color: Colors.black12);
                                          },
                                          itemCount: _perguntas.length)),
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Adicione aqui cada pergunta e respetivas respostas: ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'Monteserrat',
                                                    color: Colors.black,
                                                    letterSpacing: 2),
                                              )
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FlatButton(
                                          child: Icon(
                                              FontAwesomeIcons.plusCircle,
                                              color: parseColor("#FFCE02"),
                                              size: 30),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateQuestion()));
                                          },
                                        ),
                                      ),
                                    ]),
                                  )
                                ]),
                              ))),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: const Color(0xff72d8bf),
                            onPressed: () async {
                              missionsNotifier.currentQuestion = null;
                              if (_text.text.length > 0 &&
                                  _perguntas.length != 0 &&
                                  _textPontos.text.length != 0)
                                showConfirmar(context, _titulo, _perguntas,
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
                    ])),
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
        "Falta inserir um título ou criar, pelo menos, uma questão!",
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
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(
      BuildContext context, String titulo, List questions, int pontos) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => MyTemplateConfirmation(options),
    );

    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
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
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        createMissionQuiz(
            titulo, questions, aventuraId.id, capitulo.id, pontos);
        setState(() {
          _perguntas = [];
          _text.clear();
          _textPontos.clear();
          missionsNotifier.currentQuestion = null;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CapituloDetails(capitulo: capitulo, aventura: aventuraId)));
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
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
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
