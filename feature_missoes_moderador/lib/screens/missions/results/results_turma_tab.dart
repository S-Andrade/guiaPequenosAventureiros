
import 'package:feature_missoes_moderador/models/mission.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:feature_missoes_moderador/screens/missions/results/alunos_turma.dart';
import 'package:feature_missoes_moderador/screens/missions/results/missions_turma.dart';
import 'package:flutter/material.dart';

class ResultsTurmaTab extends StatefulWidget {

  List<Mission> missions;
  List<String> alunos;
  Turma turma;

  ResultsTurmaTab({this.missions,this.alunos,this.turma});

  @override
  _ResultsTurmaTabState createState() =>
      _ResultsTurmaTabState(missions:missions,alunos:alunos,turma:turma);
}

class _ResultsTurmaTabState extends State<ResultsTurmaTab>
    with SingleTickerProviderStateMixin {
  List<Mission> missions;
  List<String> alunos;
  TabController _tabController;
  Turma turma;

  _ResultsTurmaTabState({this.missions,this.alunos,this.turma});

  @override
  void initState() {
   
    super.initState();
    /*_tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabChange);*/
  }

  /*Future<void> _handleTabChange() async {
    await _getCurrentCapitulo(capitulo.id);
  }

  _getCurrentCapitulo(capituloId) async {
    DocumentReference documentReference =
        Firestore.instance.collection("capitulo").document(capituloId);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        setState(() {
          capitulo = new Capitulo(
              id: datasnapshot.data['id'] ?? '',
              bloqueado: datasnapshot.data['bloqueado'] ?? null,
              missoes: datasnapshot.data['missoes'] ?? []);
        });
      }
    });
    }
    */
  

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              bottomOpacity: 1,
              toolbarOpacity: 1,
              elevation: 0,
              backgroundColor: Colors.indigoAccent,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Por missão",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Amatic SC',
                            letterSpacing: 4),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Por aluno",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Amatic SC',
                            letterSpacing: 4),
                      ),
                    ),
                  ),
                ],
              )),
          body: TabBarView(
            controller: _tabController,
            children: [
              ResultsTurmaByMission(missions:this.missions,alunos:this.alunos,turma:this.turma),
              ResultsTurmaByAlunos(alunos:alunos),
              
              
            ],
          ),
        ),
      ),
    );
  }
}