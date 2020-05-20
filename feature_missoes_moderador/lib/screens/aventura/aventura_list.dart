import 'dart:async';

import 'package:feature_missoes_moderador/screens/aventura/aventura_capitulo.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura_details.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura_edit.dart';
import 'package:feature_missoes_moderador/screens/participantes/participantes.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'aventura.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'dart:ui' as ui;

class AventuraList extends StatefulWidget {
  final FirebaseUser user;
  AventuraList({this.user});

  @override
  _AventuraListState createState() => _AventuraListState(user: user);
}

class _AventuraListState extends State<AventuraList> {
  final FirebaseUser user;
  _AventuraListState({this.user});

  List<Aventura> aventuras = [];
  List<Aventura> aventura;
  Widget _buildAvatar() {
    return Row(
      children: [
        Container(
          width: 130.0,
          height: 130.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          margin: const EdgeInsets.only(top: 32.0, left: 50.0),
          padding: const EdgeInsets.all(3.0),
          child: ClipOval(
            child: Image.asset("assets/images/brain.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 50, bottom: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Bem-Vindo!",
                style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.black,
                    letterSpacing: 5,
                    fontFamily: 'Amatic SC')),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("GUIA dos pequenos Aventureiros [ Moderador ]",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: parseColor("#432F49"),
                      fontFamily: 'Monteserrat')),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 600.0,
            height: 1.0,
          ),
          Text(
              "Esta plataforma foi desenvolvida em colaboração de alunos de Licenciatura em\nEngenharia Informática da Universidade de Aveiro com o grupo de psicólogos GUIA.\n\n\nAqui poderá vizualizar as aventuras existentes, no momento:",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: 'Monteserrat')),
        ],
      ),
    );
  }

  Widget _buildVideoScroller(aventuras) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 50),
      child: SizedBox.fromSize(
        size: Size.fromHeight(300.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: aventuras.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  showOptions(aventuras[index]);
                },
                child: Card(aventura: aventuras[index]));
          },
        ),
      ),
    );
  }

  Widget _buildContent(aventuras) {
    if (aventuras.length != 0)
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatar(),
            _buildInfo(),
            _buildVideoScroller(aventuras),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getAventuras(context),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text('Erro: ${snapshot.error}');
              else
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset("assets/images/magic.jpg", fit: BoxFit.cover),
                    // or story3?
                    _buildContent(aventuras),
                  ],
                );
              break;
            default:
              return Container();
          }
        });
  }

  Future<void> getAventuras(BuildContext context) async {
    aventuras = [];
    aventura = Provider.of<List<Aventura>>(context);

    for (Aventura a in aventura) {
      if (a.moderador == user.email) {
        aventuras.add(a);
      }
    }
  }

  showOptions(aventura) async {

    final popup = BeautifulPopup(
  context: context,
  template: TemplateTerm,
);


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

    popup.show(
      title: Text(
        "Escolha uma opção:",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            width: 300,
            height: 200,
            child: Column(
              children: [
                GestureDetector(
                   onTap: () {
                            Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (context) => ParticipantesScreen(escolasId: aventura.escolas,aventuraId:aventura.id)));
                          },
                                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      width: 300,
                      child: Center(child: Text("Ver Dashboard Geral")),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#432F49"),
                              blurRadius: 4.0,
                            )
                          ]),
                    ),
                  ),
                ),
               GestureDetector(
                   onTap: () {
                            Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (context) => AventuraCapitulo(aventura: aventura)));
                          },
                                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      width: 300,
                      child: Center(child: Text("Ir para capítulos")),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#432F49"),
                              blurRadius: 4.0,
                            )
                          ]),
                    ),
                  ),
                ),
                GestureDetector(
                   onTap: () {
                            Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (context) => AventuraDetails(aventura: aventura)));
                          },
                                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      width: 300,
                      child: Center(child: Text("Editar participantes")),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#432F49"),
                              blurRadius: 4.0,
                            )
                          ]),
                    ),
                  ),
                ),
                GestureDetector(
                   onTap: () {
                            Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (context) => AventuraEdit(user: user , aventura: aventura)));
                          },
                                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 30,
                      width: 300,
                      child: Center(child: Text("Editar Aventura")),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#432F49"),
                              blurRadius: 4.0,
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            )),
      ),
      close:Container(),
      actions: [
        cancelaButton,
      ],
    );
    
   
  }
}

// CADA CARD DE AVENTURA:

class Card extends StatefulWidget {
  final Aventura aventura;
  Card({this.aventura});
  @override
  _CardState createState() => _CardState(aventura: aventura);
}

class _CardState extends State<Card> {
  _CardState({this.aventura});
  final Aventura aventura;

  BoxDecoration _buildCapa() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal
              2.5, // vertical
            ),
          )
        ],
        image: DecorationImage(
          image: AssetImage(aventura.capa),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ));
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 4.0),
      child: Text(aventura.nome,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'Monteserrat')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 230.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        decoration: _buildCapa(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(flex: 2, child: _buildInfo()),
        ]));
  }
}
