import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'aventura.dart';
import '../capitulo/capitulo_list.dart';

class AventuraCapitulo extends StatefulWidget {

  Aventura aventura;
  AventuraCapitulo({this.aventura});

  @override
  _AventuraCapitulo createState() => _AventuraCapitulo(aventura: aventura);
}

class _AventuraCapitulo extends State< AventuraCapitulo> {

  Aventura aventura;
  _AventuraCapitulo({this.aventura});

  @override
  Widget build(BuildContext context) {
        return  Container(
           decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/19.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            
              body: Stack(
                              children:[  Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 170,
                      ),
                      child: FlatButton(
                        color: parseColor("F4F19C"),
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
                    ),Padding(
                      padding: const EdgeInsets.only(top:100.0,bottom:30),
                      child: Container(
                  child: CapituloList(aventura: aventura)),
                    ),]
              ),
            ),
        );
  }
}