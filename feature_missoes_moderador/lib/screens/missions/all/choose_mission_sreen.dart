import 'package:feature_missoes_moderador/screens/missions/specific/create_audio_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_image_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_text_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_video_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/specific/create_upload_mission_screen.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';

class ChooseMissionScreen extends StatelessWidget {
  ChooseMissionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back11.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 300),
                  Text(
                    'Escolha o tipo de missão a criar',
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Amatic SC',
                        letterSpacing: 4),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
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
                                builder: (_) => CreateTextMissionScreen()));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 52,
                              child: Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/text.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                            Positioned(
                                top: 160,
                                left: 10,
                                child: Text(
                                  "Mandar uma mensagem",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: parseColor("#320a5c"),
                                blurRadius: 10.0,
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
                                builder: (_) => CreateAudioMissionScreen()));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 52,
                              child: Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/audio.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                            Positioned(
                                top: 160,
                                left: 40,
                                child: Text(
                                  "Mandar um audio",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: parseColor("#320a5c"),
                                blurRadius: 10.0,
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
                                builder: (_) => CreateUploadMissionScreen()));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 52,
                              child: Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/upload.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                            Positioned(
                                top: 160,
                                left: 15,
                                child: Text(
                                  "Pedir uma submissão",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: parseColor("#320a5c"),
                                blurRadius: 10.0,
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
                                builder: (_) => CreateUploadMissionScreen()));
                      },
                      child: Container(
                        height: 200,
                        width: 260,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              left: 52,
                              child: Container(
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/images/atividade.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                            Positioned(
                                top: 160,
                                left: 23,
                                child: Text(
                                  "Criar uma atividade",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: parseColor("#320a5c"),
                                blurRadius: 10.0,
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
                              builder: (_) => CreateVideoMissionScreen()));
                    },
                    child: Container(
                      height: 200,
                      width: 260,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 52,
                            child: Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/video.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                          Positioned(
                              top: 160,
                              left: 45,
                              child: Text(
                                "Mandar um vídeo",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4),
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#320a5c"),
                              blurRadius: 10.0,
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
                              builder: (_) => CreateTextMissionScreen()));
                    },
                    child: Container(
                      height: 200,
                      width: 260,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 52,
                            child: Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/quiz.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                          Positioned(
                              top: 160,
                              left: 10,
                              child: Text(
                                "Criar um questionário",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4),
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#320a5c"),
                              blurRadius: 10.0,
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
                              builder: (_) => CreateImageMissionScreen()));
                    },
                    child: Container(
                      height: 200,
                      width: 260,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 52,
                            child: Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/image.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                          Positioned(
                              top: 160,
                              left: 30,
                              child: Text(
                                "Mandar uma imagem",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4),
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#320a5c"),
                              blurRadius: 10.0,
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
                              builder: (_) => CreateTextMissionScreen()));
                    },
                    child: Container(
                      height: 200,
                      width: 260,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 52,
                            child: Container(
                                height: 150,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: new DecorationImage(
                                    image: ExactAssetImage(
                                        "assets/images/quiz.png"),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                          Positioned(
                              top: 160,
                              left: 56,
                              child: Text(
                                "Criar um quiz",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Amatic SC',
                                    letterSpacing: 4),
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: parseColor("#320a5c"),
                              blurRadius: 10.0,
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
