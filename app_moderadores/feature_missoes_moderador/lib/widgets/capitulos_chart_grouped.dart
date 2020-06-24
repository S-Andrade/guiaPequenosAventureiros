import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {
  Map results;

  BarChartSample2({this.results});

  @override
  State<StatefulWidget> createState() =>
      BarChartSample2State(results: this.results);
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 15;
  Map results;

  List<List> resultados;
  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  List nomes;

  int touchedGroupIndex;

  BarChartSample2State({this.results});

  @override
  void initState() {
    super.initState();
  
    List<List> finalList = [];
    nomes = [];
    for (var key in results.keys) {
      List dados = [];
      nomes.add(key);
      for (var cada in results[key].keys) {
 
        if(results[key][cada]['total']!=0.0) dados.add(
            ((results[key][cada]['dones'] * 100) / results[key][cada]['total'])
                .toInt());
        else dados.add(0);
      }
      finalList.add(dados);
    }
    if (finalList.length != 0)
      setState(() {
        
        resultados = finalList;
      });
    if (resultados.length != 0) {
      print(resultados.length);
      final List<BarChartGroupData> items = [];
      for (var a = 0; a < resultados[0].length; a++) {
        items.add(makeGroupData(a, resultados));
      }
      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Comparação em percentagem',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  const Text(
                    'Clique numa barra para ver informação e média',
                    style: TextStyle(color:   const Color(0xff72d8bf), fontSize: 8),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
             
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      barTouchData: BarTouchData(
                    
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem:(group, groupIndex, rod, rodIndex) {
              String nome;

              nome = nomes[rodIndex];

              return BarTooltipItem(
                  nome,
                  TextStyle(color: Colors.black,fontSize: 30));
            }
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is FlLongPressEnd ||
                                  response.touchInput is FlPanEnd) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            return value.toInt().toString();
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0 %';
                            } else if (value == 50) {
                              return '50 %';
                            } else if (value == 100) {
                              return '100 %';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int capitulo, List nNomes) {
  

    return BarChartGroupData(
        barsSpace: 4,
        x: capitulo,
        barRods: List<BarChartRodData>.generate(
            nNomes.length,
            (i) => BarChartRodData(
                  y: nNomes[i][capitulo].toDouble(),
                  color:  Colors.yellow,
                  width: width,
                )));
  }
}
