
import 'package:flutter/material.dart'; 
import '../../services/database.dart';
import 'package:provider/provider.dart';
import '../aventura/aventura.dart';
import 'escola.dart';
import '../aventura/aventura_details.dart';




class EscolaCreate extends StatefulWidget {
  
  Aventura aventura;
  EscolaCreate({this.aventura});


  @override
  _EscolaCreate createState() => _EscolaCreate(aventura: aventura);
}

class _EscolaCreate extends State<EscolaCreate> {

  Aventura aventura;
  _EscolaCreate({this.aventura});



  
  final _formKey = GlobalKey<FormState>();

  final myControllerNome = TextEditingController();
  
  List<Escola> listEscolas;
 

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerNome.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider<List<Escola>>.value(value: DatabaseService().escola),
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getLists(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
             body:Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                      TextFormField(
                        controller: myControllerNome,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da Escola não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Nome da Escola   '
                          )),
                          GestureDetector(
                                onTap: () {
                                  print('create');
                                  create(context);
                                },
                                child: Container(
                                  width: 460,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                        )
                                      ]),
                                  child: Center(
                                      child: Text(
                                    'Criar',
                                    style: TextStyle(
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              )
                ]
            )
            
          ));
            }); 
        }
       ));
  }

  Future<void> create(BuildContext context) async {

    print("Entrei!!");

    await getListEscolas(context);
    print(listEscolas);


    
    if (listEscolas != null){
      //create escola
      List ids_e = [];
      for (Escola e in listEscolas){
        ids_e.add(int.parse(e.id));
      }
      ids_e.sort();
      var id_escola = (ids_e.last + 1).toString();
      DatabaseService().updateEscolaData(id_escola, myControllerNome.text, []); 

      //update aventura

      List escolas = [];
      escolas = aventura.escolas;
      escolas.add(id_escola);
 

      DatabaseService().updateAventuraData(aventura.id, aventura.historia, aventura.data, aventura.local, escolas, aventura.moderador, aventura.nome);

      //back to homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) => AventuraDetails(aventura: aventura)));

    }
    
  }

    

    Future<void> getLists(BuildContext context) async{
      await getListEscolas(context);
      print(listEscolas);
      
    }
    Future<void> getListEscolas(BuildContext context) async{
      listEscolas = Provider.of<List<Escola>>(context, listen: false);
    }
    

}