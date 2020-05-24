import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_activity_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_audio_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_image_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_questionario_mission.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_quiz_mission.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_text_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_video_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_upload_mission_screen.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class ChooseMissionScreen extends StatelessWidget {
  Capitulo capitulo;
  Aventura aventura;

  ChooseMissionScreen({this.aventura, this.capitulo});

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/19.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      
        body:Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(

                  children: <Widget>[
                    FlatButton(
                            color:parseColor("F4F19C"),
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
                    SizedBox(width: 200),
                    Text(
                      'Escolha o tipo de missão a criar',
                      style: TextStyle(
                          fontSize: 40,
                          color:Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateTextMissionScreen(
                                      this.capitulo, this.aventura)));
                        },
                        child: Container(
                          height: 200,
                          width: 260,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/text.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Mandar uma mensagem",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        letterSpacing: 2,
                                        color: Colors.black,
                                        fontFamily: 'Monteserrat')),
                              )
                            ],
                          ),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateAudioMissionScreen(
                                      this.capitulo, this.aventura)));
                        },
                        child: Container(
                          height: 200,
                          width: 260,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/audio.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Mandar um audio",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        letterSpacing: 2,
                                        color: Colors.black,
                                        fontFamily: 'Monteserrat')),
                              )
                            ],
                          ),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateUploadMissionScreen(
                                      capitulo: this.capitulo,
                                      aventuraId: this.aventura)));
                        },
                        child: Container(
                          height: 200,
                          width: 260,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/upload.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Pedir uma submissão",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        letterSpacing: 2,
                                        color: Colors.black,
                                        fontFamily: 'Monteserrat')),
                              )
                            ],
                          ),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateActivityMissionScreen(
                                      this.capitulo, this.aventura)));
                        },
                        child: Container(
                          height: 200,
                          width: 260,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/atividade.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Criar uma atividade",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        letterSpacing: 2,
                                        color: Colors.black,
                                        fontFamily: 'Monteserrat')),
                              )
                            ],
                          ),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateVideoMissionScreen(
                                    this.capitulo, this.aventura)));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/video.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Mandar um vídeo",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      letterSpacing: 2,
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat')),
                            )
                          ],
                        ),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateQuestionarioMissionScreen(
                                    this.capitulo, this.aventura)));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image:
                                        ExactAssetImage("assets/images/quiz.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Criar um questionário",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      letterSpacing: 2,
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat')),
                            )
                          ],
                        ),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateImageMissionScreen(
                                    this.capitulo, this.aventura)));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/image.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Mandar uma imagem",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      letterSpacing: 2,
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat')),
                            )
                          ],
                        ),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateQuizMissionScreen(
                                    this.capitulo, this.aventura)));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image:
                                        ExactAssetImage("assets/images/quiz.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Criar um quiz",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      letterSpacing: 2,
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat')),
                            )
                          ],
                        ),
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
                      ),
                    ),
                  ),
                ],
              )
            ],
          
        ),
      ),
    );
  }
}
