
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../notifier/missions_notifier.dart';


class StatisticsScreen extends StatefulWidget {
  StatisticsScreen();

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List missoes;
  int _index;
  int _indexMission;
  List<double> data;
  Map<String, double> dataMap;
  double _muitaLuz;
  double _poucaLuz;
  double _algumaLuz;
  double _nenhumaLuz;

  _StatisticsScreenState();

  @override
  void initState() {




     super.initState();

     

     _muitaLuz=0;
     _nenhumaLuz=0;
     _poucaLuz=0;
     _algumaLuz=0;

     dataMap=new Map();

    _index = 0;
    var i=0;

    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);

    missoes = missionsNotifier.missionsList;


for(var b in missoes){

      if (b.type=="Text") _indexMission=i;
      else i++;
    }
    
    
   
    for (var a in missoes[_indexMission].resultados) {
      
      if (a["aluno"] == "gan01@cucu.pt") {
      
        break;
      }
      _index++;
    }

   
  }

  @override
  Widget build(BuildContext context) {

 
for(var luz in missoes[_indexMission].resultados[_index]["lightData"]){
  if((luz>=0) & (luz<4)) _nenhumaLuz++;
  else if((luz>=3) & (luz<20)) _poucaLuz++;
  else if((luz>=20) & (luz<40)) _algumaLuz++;
  else _muitaLuz++;
}
dataMap.putIfAbsent("Muita luz", () => _muitaLuz);
dataMap.putIfAbsent("Alguma luz", () => _algumaLuz);
dataMap.putIfAbsent("Pouca luz", () => _poucaLuz);
dataMap.putIfAbsent("Muito pouca luz", () => _nenhumaLuz);
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Results/Statistics page'),
        ),
        body: ListView(children: [
          Column(
            children: <Widget>[
              Text("Estatísticas das missões:"),
              Padding(
                padding: const EdgeInsets.only(top:30,bottom:30,left:60),
                child: Row(children: <Widget>[
                Container(
                  height: 400,
                  width: 300,
                  child: new Sparkline(
                    lineWidth: 6.0,
                    lineGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.red[800], Colors.red[200]],
                    ),
                    data: missoes[_indexMission].resultados[_index]["movementData"].cast<double>(),
                  ),
                ),
                Container(
                  height: 500,
                  width:400,
                  child: new PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      legendStyle: TextStyle(fontSize:20.0),
      chartValueStyle: TextStyle(fontSize: 25.0,color:Colors.black),
      chartRadius: MediaQuery
          .of(context)
          .size
          .width / 2.7,
      showChartValuesInPercentage: true,
      showChartValues: true,
      
      )
      ),]),
              ),
              
              Column(
                children: missoes
                    .map(
                      (e) => Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                              top: 30.0,
                              left: 100,
                            ),
                            child: Row(children: [
                              Container(
                                child: Column(children: [
                                  new CircularPercentIndicator(
                                    radius: 200.0,
                                    animation: true,
                                    animationDuration: 2000,
                                    lineWidth: 20.0,
                                    startAngle: 45.0,
                                    percent: (e.resultados[_index]
                                                    ['timeVisited'] /
                                                60)
                                            .round() /
                                        60,
                                    center: new Text(
                                      ((e.resultados[_index]['timeVisited'] /
                                                      60)
                                                  .round())
                                              .toString() +
                                          " minutos",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    backgroundColor: Colors.grey[200],
                                    progressColor: Colors.red,
                                  ),
                                ]),
                              ),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80.0, bottom: 40),
                                  child: Text(e.title,
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 80.0),
                                  child: Text(
                                      "Entrou " +
                                          e.resultados[_index]["counterVisited"]
                                              .toString() +
                                          " vezes",
                                      style: const TextStyle(fontSize: 20.0)),
                                )
                              ]),
                            ])),
                      ]),
                    )
                    .toList(),
              )
            ],
          ),
        ]));
  }
}
