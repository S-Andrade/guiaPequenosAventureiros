import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  String _titulo;
  String _conteudo;

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
                                onChanged: (value) {
                                  _titulo=value;
                                },
                                maxLength: 50,
                                maxLengthEnforced: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4,
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
                                onChanged: (value) {
                                  _conteudo=value;
                                },
                                maxLength: 300,
                                maxLengthEnforced: true,
                                style: TextStyle(
                                    color: Colors.black,
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
                            print(_titulo);
                            print(_conteudo);
                          },
                          child: Text(
                            "Enviar missão",
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
}

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final int linhas;
  final double altura;
  final int carateres;
  String titulo;
  String conteudo;
  final String type;

  InputField(
      {this.label,
      this.content,
      this.linhas,
      this.altura,
      this.carateres,
      this.type});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              width: 100.0,
              child: Text(
                "$label",
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
              height: altura,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.purple[50],
              ),
              child: TextField(
                onChanged: (value) {
                  if (type == "titulo") {
                    titulo = value;
                  } else if (type == "conteudo") {
                    conteudo = value;
                  }
                },
                maxLength: carateres,
                maxLengthEnforced: true,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Amatic SC',
                    letterSpacing: 4,
                    fontSize: 20),
                maxLines: linhas,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[50],
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "$content",
                  fillColor: Colors.blue[50],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
