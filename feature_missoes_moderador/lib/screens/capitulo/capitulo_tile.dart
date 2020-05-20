import 'package:flutter/material.dart';
import 'capitulo.dart';
import '../aventura/aventura.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitulo_details.dart';

class CapituloTile extends StatelessWidget {
  String capituloId;
  Aventura aventura;
  int index;

  CapituloTile({this.capituloId, this.aventura,this.index});

  Capitulo capitulo;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getCapitulo(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text('Erro: ${snapshot.error}');
              else
                  return Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CapituloDetails(
                                    capitulo: capitulo, aventura: aventura)));
                      },
                     
                      
                        child: Container(

             height: 580,
         
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Padding(
                                   padding: const EdgeInsets.only(top:15.0,left:30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                              
                                       
                                        Flexible(
                                          child: Text("Capítulo " + capitulo.id,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 70.0,
                                                 
                                                  color: Colors.black,
                                                  fontFamily: 'Amatic SC')),
                                        ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius:
                                      5.0, // has the effect of softening the shadow
                                  spreadRadius:
                                      2.0, // has the effect of extending the shadow
                                  offset: Offset(
                                    0.0, // horizontal
                                    2.5, // vertical
                                  ),
                                )
                              ],
                              color:Colors.white,
                              image: DecorationImage(
                                image: AssetImage("assets/images/chapter_"+index.toString()+".png"),
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.topCenter,
                              )),
                        ),
                      ),
                    
                ),
                  );

              break;
            default:
              return Container();
          }
        });
  }

  Future<void> getCapitulo() async {
    DocumentReference documentReference =
        Firestore.instance.collection("capitulo").document(capituloId);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        capitulo = Capitulo(
            id: datasnapshot.data['id'] ?? '',
            bloqueado: datasnapshot.data['bloqueado'] ?? null,
            missoes: datasnapshot.data['missoes'] ?? []);
        flag = true;
      } else {
        print("No such capitulo");
      }
    });
  }
}
