import 'package:flutter/material.dart';


class  CapitulosDetailsMissoes extends StatelessWidget {

  final List missoes;
  final String id;
  CapitulosDetailsMissoes({ this.missoes , this.id});

  @override
  Widget build(BuildContext context) {
    print(missoes);
    return  Scaffold(
      appBar: AppBar(
          title: Text(id)
        ),
      body:  ListView.builder(
        itemCount: missoes.length,
        itemBuilder: (context,index) {
          return Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                title: Text(missoes[index])
              ),
            ),
          );
        }
      )
    );
    
    
   
  }
}