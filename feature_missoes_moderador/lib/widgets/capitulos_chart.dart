import 'dart:async';
import 'dart:math';

import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample1 extends StatefulWidget {
  Map results;

  BarChartSample1({this.results});

  @override
  State<StatefulWidget> createState() =>
      BarChartSample1State(results: this.results);
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.indigoAccent[300];
  final Duration animDuration = const Duration(milliseconds: 250);
  Map results;
  int touchedIndex;
  List<double> resultados;

  BarChartSample1State({this.results});

  @override
  void initState() {
    resultados = [];

    for (var a in results.values) {
      setState(() {
        if (a['total'] != 0)
          resultados.add((a['dones'] * 100) / a['total']);
        else
          resultados.add(0.0);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (resultados.length != 0) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Clique numa barra para mais informações',
                  style: TextStyle(color: parseColor("#f4a09c"), fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return Container();
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.yellow,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(resultados.length, (i) {
        return makeGroupData(i, resultados[i], isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.all(20),
            tooltipBgColor: Colors.indigoAccent[100],
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;

              weekDay = 'Capitulo ' + groupIndex.toString();

              return BarTooltipItem(
                  weekDay +
                      '\n\n' +
                      results[groupIndex]['dones'].toInt().toString() +
                      " / " +
                      results[groupIndex]['total'].toInt().toString() +
                      " missões feitas",
                  TextStyle(color: Colors.black, fontSize: 18));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
            margin: 16,
            getTitles: (double value) {
              return (value.toInt()).toString();
            }),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}
