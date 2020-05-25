import 'package:flutter/material.dart';
import '../escola/escola_list.dart';
import '../escola/escola_create.dart';
import 'aventura.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';


class AventuraDetails extends StatefulWidget {

  Aventura aventura;
  AventuraDetails({this.aventura});

  @override
  _AventuraDetails createState() => _AventuraDetails(aventura: aventura);
}

class _AventuraDetails extends State<AventuraDetails> {

  Aventura aventura;
  _AventuraDetails({this.aventura});

  @override
  Widget build(BuildContext context) {
        return  Container(
           decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/19.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
          child: new Scaffold(
             backgroundColor: Colors.transparent,
              body: Stack(
                              children:[ Positioned(top:50,left:170,
                                                                      child: FlatButton(
                            color:parseColor("F4F19C"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                    color: Colors.black,
                                 
                                    fontFamily: 'Monteserrat',
                                    letterSpacing: 2,
                                    fontSize: 20),
                            ),
                          ),
                                  ), Padding(
                  padding: const EdgeInsets.all(150.0),
                  child: Container( decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius:
                                          5.0, // has the effect of softening the shadow
                                      spreadRadius:
                                          2.0, // has the effect of extending the shadow
                                      offset: Offset(
                                        0.0, // horizontal
                                        2.5, // vertical
                                      ),
                                    )
                                  ]),child: EscolaList(aventura: aventura)),
                ),]
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => EscolaCreate(aventura: aventura)));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: const Color(0xff72d8bf),
                ),
              ),
            ),
        );
  }
}