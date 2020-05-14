import 'dart:async';

import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/screens/missions/all/create_mission_screen.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateTextMissionScreen extends StatelessWidget {
  String _titulo;
  String _conteudo;

  Aventura aventuraId;
  Capitulo capitulo;

  CreateTextMissionScreen(this.capitulo, this.aventuraId);

  final _text = TextEditingController();
  final _text2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2.8,
                height: MediaQuery.of(context).size.height,
                color: parseColor("#320a5c"),
                child: Padding(
                  padding: EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
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
                            "Enviar uma mensagem de texto",
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
                            "As crianças irão receber uma missão, em forma de mensagem.",
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
                padding: EdgeInsets.only(top: 100.0, left: 70.0, bottom: 10.0),
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
                                controller: _text2,
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
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              child: Text(
                                "Conteúdo",
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
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.purple[50],
                              ),
                              child: TextField(
                                controller: _text,
                                onChanged: (value) {
                                  _conteudo = value;
                                },
                                maxLength: 300,
                                maxLengthEnforced: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4,
                                    fontSize: 20),
                                maxLines: 10,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue[50],
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Insira  a mensagem",
                                  fillColor: Colors.blue[50],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 70.0,
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
                          onPressed: () {
                            if (_text.text.length > 0 && _text2.text.length > 0)
                              showConfirmar(context, _titulo, _conteudo);
                            else
                              showError(context);
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
    );
  }

  showError(BuildContext context) {
    // configura o button

    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Por favor preencha todos os campos!",
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
    Timer(Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(BuildContext context, String titulo, String conteudo) {
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
        createMissionTextInFirestore(titulo, conteudo, aventuraId.id, capitulo.id);
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => TabBarMissions(
                capitulo: capitulo, aventura: aventuraId)));
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
