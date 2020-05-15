import 'package:google_fonts/google_fonts.dart';
import 'aventura.dart';
import 'package:flutter/material.dart';
import 'aventura_details.dart';

class AventuraTile extends StatelessWidget {
  final Aventura aventura;
  AventuraTile({this.aventura});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AventuraDetails(aventura: aventura)));
          },
          child: FractionallySizedBox(
            heightFactor: 0.7, //
            child: Container(
//              height: 560,
//            constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(aventura.nome,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AventuraDetails(aventura: aventura)));
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "SEGUIR AVENTURA",
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                height: 1,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color:  Color(0xFF333351)),
                          ),
                        ),
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
                      blurRadius: 5.0, // has the effect of softening the shadow
                      spreadRadius:
                          2.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal
                        2.5, // vertical
                      ),
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(aventura.capa),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
