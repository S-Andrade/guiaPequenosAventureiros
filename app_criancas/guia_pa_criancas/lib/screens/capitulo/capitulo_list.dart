import 'package:app_criancas/widgets/color_loader_5.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitulo.dart';
import 'package:provider/provider.dart';
import 'capitulo_tile.dart';

class CapituloList extends StatefulWidget {
  final List capitulos;
  CapituloList({this.capitulos});

  @override
  _CapituloListState createState() => _CapituloListState(capitulos: capitulos);
}

class _CapituloListState extends State<CapituloList> {
  final List capitulos;
  _CapituloListState({this.capitulos});
  List<Capitulo> cap;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    if (cap == null) {
      getCapitulos();
      return ColorLoader5();
    } else {
      return FutureBuilder<void>(
          future: getCapitulos(),
          builder: (context, AsyncSnapshot<void> snapshot) {
            return GridView.builder(
//                padding: EdgeInsets.symmetric(vertical: screenHeight > 1000 ? screenHeight/6 : 100),
                itemCount: cap.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 800 ? 4 : 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return CapituloTile(capitulo: cap[index]);
                });
          });
    }
  }

  Future<void> getCapitulos() async {
    cap = [];
    final capitulo = Provider.of<List<Capitulo>>(context);
    for (Capitulo capi in capitulo) {
      if (capitulos.contains(capi.id)) {
        cap.add(capi);
      }
    }
  }
}
