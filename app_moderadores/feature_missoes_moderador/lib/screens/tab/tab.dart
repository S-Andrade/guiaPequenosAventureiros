import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/missions/all/create_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/results/results_dashboard_turmas.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import '../aventura/aventura.dart';
import '../aventura/aventura_capitulo.dart';

class TabBarMissions extends StatefulWidget {
  Aventura aventura;
  Capitulo capitulo;

  TabBarMissions({this.capitulo, this.aventura});

  @override
  _TabBarMissionsState createState() =>
      _TabBarMissionsState(capitulo: capitulo, aventura: aventura);
}

class _TabBarMissionsState extends State<TabBarMissions>
    with SingleTickerProviderStateMixin {
  Aventura aventura;
  Capitulo capitulo;
  TabController _tabController;

  _TabBarMissionsState({this.capitulo, this.aventura});

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabChange);
  }

  Future<void> _handleTabChange() async {
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

  @override
  Widget build(BuildContext context) {
/*,leading: IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => (this.capitulo,this.aventuraId)));*/
    return Container(
       decoration:
              BoxDecoration(
              image: DecorationImage(
          image: AssetImage("assets/images/animated18.gif"),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar:  TabBar(
                  controller: _tabController,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(top:40.0),
                      child: Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Resultados",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                  fontFamily: 'Monteserrat')),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:40.0),
                      child: Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Missões",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                  fontFamily: 'Monteserrat')),
                        ),
                      ),
                    ),
                  ],
                ),
            body: TabBarView(
              controller: _tabController,
              children: [
                ResultsDashboardTurmasScreen(
                    aventuraId: this.aventura.id, capitulo: this.capitulo),
                CreateMissionScreen(
                    aventura: this.aventura, capitulo: this.capitulo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
