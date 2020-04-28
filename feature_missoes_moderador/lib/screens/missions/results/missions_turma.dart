import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_normal.dart';
import 'package:feature_missoes_moderador/screens/missions/results/list_upload.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';


class ResultsTurmaByMission extends StatelessWidget {
  
  List<Mission> missions;
  List<String> alunos;
  Turma turma;

  ResultsTurmaByMission({this.missions,this.alunos,this.turma});

  
  @override
  Widget build(BuildContext context) {

      return Scaffold(
          body: 
       
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back11.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
                          children: [
                            Text("ola"),
                            Expanded(
                                                      child: GridView.count(
     
                crossAxisCount: 1,
                childAspectRatio: MediaQuery.of(context).size.height / 70,
                
                children: List.generate(missions.length, (index) {
                  return GestureDetector(
                    onTap: () { 
                      if(missions[index].type=='Video' || missions[index].type=='Image' || missions[index].type=='Text' || missions[index].type=='Activity') {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ResultsByMissionNormalForTurma(mission:this.missions[index],alunos:this.alunos,turma:this.turma)));
                      }
                      else if(missions[index].type=='UploadImage' || missions[index].type=='UploadVideo'){
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ResultsByMissionUploadForTurma(mission:this.missions[index],alunos:this.alunos,turma:this.turma)));
                      }
                    },
                                      child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 100,
                        child:Padding(
                          padding: const EdgeInsets.only(left:70.0,top:15),
                          child: Text(missions[index].title+"              [ "+missions[index].type+" ]                              resultados",style: TextStyle(
                          fontSize: 35, fontFamily: 'Amatic SC', letterSpacing: 4, fontWeight: FontWeight.w900),),
                        ),
                         decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: parseColor("#320a5c"),
                                      blurRadius: 10.0,
                                    )
                                  ]),
                      ),
                    ),
                  );
                })),
                          ),
                          ])
     )
          ,
      );
  }

         
}
