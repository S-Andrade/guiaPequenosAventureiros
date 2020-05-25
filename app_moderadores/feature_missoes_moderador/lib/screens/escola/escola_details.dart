import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/escola/escola.dart';
import '../turma/turma_list.dart';
import '../turma/turma_create.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';

class EscolaDetails extends StatefulWidget {
  Escola escola;
  EscolaDetails({this.escola});
  @override
  _EscolaDetails createState() => _EscolaDetails(escola: escola);
}

class _EscolaDetails extends State<EscolaDetails> {
  Escola escola;
  _EscolaDetails({this.escola});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/19.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(
            top: 35,
            left: 150,
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
          ),
          Padding(
            padding: const EdgeInsets.all(120.0),
            child: Container(
                decoration: BoxDecoration(
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
                    ]),
                child: Container(child: TurmaList(escola: escola))),
          ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TurmaCreate(escola: escola)));
            },
            child: Icon(Icons.add),
            backgroundColor: const Color(0xff72d8bf),
          ),
        ),
      ),
    );
  }
}
