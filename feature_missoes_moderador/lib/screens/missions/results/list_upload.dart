import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/widgets/video_player.dart';
import 'package:flutter/material.dart';


import '../../../widgets/color_parser.dart';

class ResultsByMissionUploadForTurma extends StatefulWidget {
  Mission mission;
  List<String> alunos;
  Turma turma;

  ResultsByMissionUploadForTurma({this.mission, this.alunos, this.turma});

  @override
  _ResultsByMissionUploadForTurmaState createState() =>
      _ResultsByMissionUploadForTurmaState(
          mission: this.mission, alunos: this.alunos, turma: this.turma);
}

class _ResultsByMissionUploadForTurmaState
    extends State<ResultsByMissionUploadForTurma> {
  Mission mission;
  List<String> alunos;
  Turma turma;
  Map results;
  String url;

  _ResultsByMissionUploadForTurmaState({this.mission, this.alunos, this.turma});

  @override
  void initState() {
    super.initState();
    results = {};

    for (var aluno in alunos) {
   
      for (var campo in mission.resultados) {
        print(campo['aluno']);
        if (campo['aluno'] == aluno) {
          
          setState(() {
            results[aluno] = campo;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(title: new Text('Upload Results Por Turma')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back11.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 60.0,
              bottom: 20,
            ),
            child: Text(
                "Turma " +
                    turma.nome +
                    "                       " +
                    alunos.length.toString() +
                    " alunos",
                style: TextStyle(
                    fontSize: 45, fontFamily: 'Amatic SC', letterSpacing: 4)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
            child: Container(
                height: 70,
                color: Colors.white,
                child: Row(children: [
                  Text(
                    '       Aluno               Missão feita          Foto/Vídeo Uploaded',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Amatic SC',
                        color: Colors.indigo,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900),
                  )
                ])),
          ),
          Expanded(
            child: new ListView.separated(
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Column(children: [
                    Container(
                        height: 150,
                        color: Colors.white,
                        child: Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 30),
                            child: Container(
                              height: 100,
                              width: 170,
                              child: Center(
                                child: Text(
                                  alunos[index],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Amatic SC',
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new Builder(
                                builder: (BuildContext) =>
                                    results[alunos[index]]['done']
                                        ? Container(
                                            height: 80,
                                            width: 130,
                                            child: Center(
                                              child: Text(
                                                "Feita",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.0),
                                              ),
                                            ),
                                            color: Colors.green[300])
                                        : Container(
                                            height: 80,
                                            child: Center(
                                              child: Text(
                                                "Não feita",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.0),
                                              ),
                                            ),
                                            width: 130,
                                            color: Colors.red[300])),
                          ),
                         
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: new Builder(
                                builder: (BuildContext) =>
                                    results[alunos[index]]['done']
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FlatButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.indigo,
                                                      width: 5)),
                                              color: Colors.white,
                                              textColor: Colors.black,
                                              padding: EdgeInsets.all(8.0),
                                              onPressed: () {
                                                showImageOrVideo(
                                                    context,
                                                    results[alunos[index]]
                                                        ['linkUploaded'],
                                                    mission);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Ver".toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()),
                          ),
                        ]))
                  ]),
                );
              },
              itemCount: alunos.length,
              separatorBuilder: (context, int index) {
                return Divider(height: 30, color: Colors.black12);
              },
            ),
          ),
        ]),
      ),
    );
  }

  showImageOrVideo(BuildContext context, link, mission) {


         
    Widget continuaButton = FlatButton(
      child: Text(
        "Ok",
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

    AlertDialog alertImage = AlertDialog(
      title: Text(
        "Imagem uploaded pelo aluno",
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
          width: 700,
          height: 400,
          child: Container(
            height: 230,
            width: 700,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(link),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    AlertDialog alertVideo = AlertDialog(
      title: Text(
        "Video uploaded pelo aluno",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left:20.0,top:10,right: 20,bottom:0),
        child: Container(
          width: 700,
          height: 450,
          child: Stack(children: [
            Positioned(
              top: 5,
              left: 100,
              child: Container(
                width: 500,
                height: 370,
                decoration: BoxDecoration(
                    color: parseColor("#320a5c"),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: parseColor("#320a5c"),
                        blurRadius: 10.0,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChewieDemo(
                                                      link: link),
                ),
              ),
            ),
         
     
          ]),
        ),
      ),
      actions: [
        continuaButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (mission.type == 'UploadImage') {
          return alertImage;
        } else {

          return alertVideo;
        }
      },
    );
  }
}
