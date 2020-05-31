import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feature_missoes_moderador/screens/home_screen.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import '../historia/historia.dart';
import 'aventura.dart';
import '../historia/historia_create.dart';
import 'package:flutter/cupertino.dart';







class AventuraEdit extends StatefulWidget {
  FirebaseUser user;
  Aventura aventura;
  AventuraEdit({this.user, this.aventura});


  @override
  _AventuraEdit createState() => _AventuraEdit(user:user, aventura:aventura);
}

class _AventuraEdit extends State<AventuraEdit> {

   FirebaseUser user;
  Aventura aventura;
  _AventuraEdit({this.user, this.aventura});

  
    final _formKeyAventura = GlobalKey<FormState>();
    final _formKeyHistoria = GlobalKey<FormState>();


  



  List<Historia> listHistorias;
  List<Aventura> listAventura;
  String dropdownValue = "Historia";
  var listDropdown = <String>["Historia"];
  var image;

  int currentStep = 0;

  String _aventura_nome;
  String _aventura_local;

  

 
  @override
  Widget build(BuildContext context) {
   
    List<Step> steps =[
      Step(
        title: const Text('Dados da Aventura'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[

            Form(
          key: _formKeyAventura,
          child: Column(children: <Widget>[
             TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da aventura não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Nome da Aventura   '
                          ),
                          onSaved: (input) => _aventura_nome = input,
                      ),
                      TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Local não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Local   '
                          ),
                          onSaved: (input) => _aventura_local = input,
                          ),
          ],) )

              ])
      ),
      Step(
        title: const Text('Dados da Historia'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
          Form(
          key: _formKeyHistoria,
          child: Column(children: <Widget>[
             DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color: Colors.deepPurple
                          ),
                          validator: (value){
                             if (value == "Historia") {
                              return 'Historia não selecionada';
                            }
                          },
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: listDropdown
                            .map<DropdownMenuItem<String>>((String value) {
                          
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                        ),
          ])),
              
                
              IconButton(icon: Icon(Icons.add), onPressed: (){addHistoria();}),
              ])
      )];

    
    goTo(int step) {
      setState(() => currentStep = step);
    }

    next() {
      if(currentStep == 0){
         if(_formKeyAventura.currentState.validate()){
          _formKeyAventura.currentState.save();
          goTo(currentStep + 1);
          }
      }
      if(currentStep == 1){
        if(_formKeyHistoria.currentState.validate()){
          _formKeyHistoria.currentState.save();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Pronto a criar"),
                content: new Text("Está pronto para editar uma nova aventura!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          }
      }
    }

    cancel(){
      if(currentStep == 0){
         _formKeyAventura.currentState.reset();
      }
      if(currentStep == 1){
        setState(() {
          dropdownValue = "Historia";
        });
      }
    }
    



    return MultiProvider(
      providers: [
        StreamProvider<List<Historia>>.value(value: DatabaseService().historia),
        StreamProvider<List<Aventura>>.value(value: DatabaseService().aventura),
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getLists(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              appBar: AppBar(
                    title: Text('Editar aventura'),
                  ),
                  body: Column(children: <Widget>[
                    Expanded(
                      child: Stepper(
                        steps: steps,
                        currentStep: currentStep,
                        onStepContinue: next,
                        onStepTapped: (step) => goTo(step),
                        onStepCancel: cancel,
                      ),
                    ),

                     Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: GestureDetector(
                                onTap: () {
                        
                                  edit(context);
                                },
                                child: Container(
                                  width: 300,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                        )
                                      ]),
                                  child: Center(
                                      child: Text(
                                      'Editar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              ),
                    )

                  ]));



            });}));   

              
  }

  

  Future<void> addHistoria() async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriaCreate()));
  }
 
    Future<void> getLists(BuildContext context) async{
      await getListAventura(context);
    
      await getListHiostoria(context);
  
      listDropdown = <String>["Historia"];
 
      if(listHistorias != null){
        for (Historia h in  listHistorias){                             
          listDropdown.add(h.titulo);
        } 
      }
   
      
    }



    Future<void> getListAventura(BuildContext context) async{
      listAventura = Provider.of<List<Aventura>>(context, listen: false);
    }
    Future<void> getListHiostoria(BuildContext context) async{
      listHistorias = Provider.of<List<Historia>>(context, listen: false);
    }
    

    Future<void> edit(BuildContext context) async {
      
      await getListAventura(context);
   
      await getListHiostoria(context);


       if(_aventura_nome  == null || _aventura_local == null || dropdownValue == "Historia" ){

       showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema a editar aventura"),
                content: new Text("Tem de prencher todos os campos!"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  new FlatButton(
                    child: new Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

    }else{
      if (listHistorias != null && listAventura !=null){
        //get id historia
        String id_historia = "";
        for(Historia h in listHistorias){
          if (h.titulo == dropdownValue){
            id_historia = h.id;
          }
        }


        //edit AVENTURA
          DatabaseService().updateAventuraData(aventura.id, id_historia, Timestamp.now(), _aventura_local, aventura.escolas, user.email, _aventura_nome, aventura.capa);
       

        //back to homepage
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)));
      }
    }
      
      
    }

}