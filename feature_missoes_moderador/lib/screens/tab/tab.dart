import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/missions/all/create_mission_screen.dart';
import 'package:flutter/material.dart';

class TabBarMissions extends StatefulWidget {
  String aventuraId;
  Capitulo capitulo;

  TabBarMissions({this.capitulo, this.aventuraId});

  @override
  _TabBarMissionsState createState() =>
      _TabBarMissionsState(capitulo: capitulo, aventuraId: aventuraId);
}

class _TabBarMissionsState extends State<TabBarMissions>
    with SingleTickerProviderStateMixin {
  String aventuraId;
  Capitulo capitulo;
  TabController _tabController;

  _TabBarMissionsState({this.capitulo, this.aventuraId});

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
    print(capitulo.missoes.length.toString());

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
              Icon(Icons.directions_transit),
              CreateMissionScreen(
                  aventuraId: this.aventuraId, capitulo: this.capitulo),
              
            ],
          ),
        ),
      ),
    );
  }
}
