import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../aventura/aventura.dart';
import 'capitulo_tile.dart';
import '../historia/historia.dart';
import '../../widgets/color_loader.dart';

class CapituloList extends StatefulWidget {
  Aventura aventura;
  CapituloList({this.aventura});

  @override
  _CapituloList createState() => _CapituloList(aventura: aventura);
}

class _CapituloList extends State<CapituloList> {
  Aventura aventura;
  _CapituloList({this.aventura});

  List capitulos;
  
 
  PageController _controller = PageController(viewportFraction: 0.80);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getHistoria(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text('Erro: ${snapshot.error}');
              else
                return PageView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  pageSnapping: true,

                  itemCount: capitulos.length,
                  itemBuilder: (context,index) {
                   
                  return CapituloTile(capituloId:capitulos[index],aventura:aventura,index:index);
                  
                  }
              );
              break;
            default:
              return Container();
          }
        });
  }

  Future<void> getHistoria() async {
    Historia historia;
    DocumentReference documentReference =
        Firestore.instance.collection("historia").document(aventura.historia);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        historia = Historia(
          id: datasnapshot.data['id'].toString() ?? '',
          titulo: datasnapshot.data['titulo'].toString() ?? '',
          capitulos: datasnapshot.data['capitulos'] ?? [],
          capa: datasnapshot.data['capa'] ?? '',
        );
        
      } else {
        print("No such historia");
      }
    });

    capitulos = historia.capitulos;
  }
}
