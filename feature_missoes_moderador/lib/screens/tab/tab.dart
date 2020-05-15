import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/missions/all/create_mission_screen.dart';
import 'package:feature_missoes_moderador/screens/missions/results/results_dashboard_turmas.dart';
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
    return Scaffold(
     
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraCapitulo(aventura: aventura)));}),
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
                        "Resultados",
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
                        "Missões",
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
              ResultsDashboardTurmasScreen(aventuraId: this.aventura.id, capitulo: this.capitulo),
              CreateMissionScreen(
                  aventura: this.aventura, capitulo: this.capitulo),
              
            ],
          ),
        ),
      ),
    );
  }
}
