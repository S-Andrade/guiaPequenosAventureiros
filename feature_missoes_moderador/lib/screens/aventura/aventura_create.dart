import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feature_missoes_moderador/screens/home_screen.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import '../historia/historia.dart';
import 'aventura.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '../historia/historia_create.dart';
import 'package:flutter/cupertino.dart';
import '../turma/turma.dart';
import '../../services/password_generator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../escola/escola.dart';






class AventuraCreate extends StatefulWidget {
  final FirebaseUser user;
  AventuraCreate({this.user});


  @override
  _AventuraCreate createState() => _AventuraCreate(user:user);
}

class _AventuraCreate extends State<AventuraCreate> {

   final FirebaseUser user;
  _AventuraCreate({this.user});

  
    final _formKey = GlobalKey<FormState>();
    final _formKeyAventura = GlobalKey<FormState>();
    final _formKeyHistoria = GlobalKey<FormState>();


  

  List<Widget> lista_principal = [];

  List<Historia> listHistorias;
  List<Aventura> listAventura;
  List<Turma> listTurmas;
  List<Escola> listEscolas;
  String dropdownValue = "Historia";
  var listDropdown = <String>["Historia"];
  var image;
  Map<String, List<String>> participantes = {};
  List<Widget> listOfFields = [];
  List<String> escolas = [];
  List<List<List<String>>> turmas = [];
  int currentStep = 0;
  int counter = 0;
  String _escola;
  String _turma;
  String _nAlunos;
  String _professor;
  List<List<int>> posicoes =[];
  int posicoes_counter = 0;
  int escola_counter = 0;
  String _aventura_nome;
  String _aventura_local;
  int counter_principal = 0;
  List flags_escolas = [];

 
 
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
                         
                          decoration: new InputDecoration(
                            
                            labelText: "Nome da aventura",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                          onSaved: (input) => _aventura_nome = input,
                      ),
                      TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Local não inserido';
                            }
                          },
                         
                          decoration: new InputDecoration(
                            labelText: "Local",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
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
                            color: Colors.blue
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
              
                GestureDetector(
                                onTap: () {
                                  addHistoria();
                                },
                                child: Container(
                                  width: 300,
                                  height: 50,
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
                                      'Criar Historia',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              ),
              ])
      ),
      Step(
        title: const Text('Dados dos participantes'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            GestureDetector(
                                onTap: () {
                              addNewFieldEscola(); 
                                },
                                child: Container(
                                  width: 300,
                                  height: 50,
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
                                      'Adicionar escola',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              ),
            
          Column(children: listOfFields)
          ]
          
        )
      )
    ];

    
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
          goTo(currentStep + 1);
          }
      }
      if(currentStep == 2){
        int total_inserido = escolas.length;
        for(List l in turmas){
          total_inserido += l.length;
        }
        int total_esperado = listOfFields.length;
         if(total_esperado == 0 ){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema a inserir participantes"),
                content: new Text("Têm de inserir pelo menos uma escola e uma turma!"),
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
        else if (total_esperado != total_inserido){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema a inserir participantes"),
                content: new Text("É necessario confirmar todos os campos!"),
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
        else if(escolas.length != turmas.length){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema a inserir participantes"),
                content: new Text("Todas as escolas têm de ter pelo menos uma turma!"),
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
        else if (total_esperado == total_inserido){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Pronto a criar"),
                content: new Text("Está pronto para criar uma nova aventura!"),
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
      if(currentStep == 2){
        setState(() {
          listOfFields = [];
          escolas = [];
          turmas = [];
          counter = 0;
          posicoes_counter = 0;
          escola_counter = 0;
        });
      }
    }
    




    return MultiProvider(
      providers: [
        StreamProvider<List<Historia>>.value(value: DatabaseService().historia),
        StreamProvider<List<Aventura>>.value(value: DatabaseService().aventura),
        StreamProvider<List<Turma>>.value(value: DatabaseService().turma),
        StreamProvider<List<Escola>>.value(value: DatabaseService().escola)
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getLists(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              appBar: AppBar(
                    title: Text('Criar aventura'),
                  ),
                  body: Column(
                    children: <Widget>[
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
                                  print('create');
                                  create(context);
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
                                      'Criar',
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
                    
                    ]
                  ));



            });}));   

              
  }

  

  Future<void> addHistoria() async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriaCreate()));
  }
  Future<void> create(BuildContext context) async {
    
   

    if(_aventura_nome  == null || _aventura_local == null || dropdownValue == "Historia" || escolas.length == 0 || turmas.length == 0){

       showDialog(
            context: context,
            builder: (BuildContext context) {
              // retorna um objeto do tipo Dialog
              return AlertDialog(
                title: new Text("Problema a criar aventura"),
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
       List list_Escolas_id = [];

    for (int i = 0; i < escolas.length; i++){
      List list_Turmas_id = [];
     
      List ids_e = [];
        for (Escola e in listEscolas){
          ids_e.add(int.parse(e.id));
        }
        ids_e.sort();
        var id_escola = (ids_e.last + 1).toString();

      for (List turma in turmas[i]){
           
        await getListTurmas(context);
       

        //id turma
        List ids_t = [];
            for (Turma t in listTurmas){
              int d = int.parse(t.id, onError: (e) => null);
              if (d != null){
                ids_t.add(int.parse(t.id));
              }
              
            }
            ids_t.sort();
            var id_turma = (ids_t.last + 1).toString();

        List alunos = [];
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        if (listTurmas != null){
           //gerar alunos
            var in_escolas =  escolas[i].substring(0,3).toLowerCase().trim()+ turma[0] ;
            var letras_escola = in_escolas+ "@";


            var file_name = in_escolas + ".txt";

            final directory = await getApplicationDocumentsDirectory();
            final p = directory.path;

            
            File file = await new File('$p/$file_name');
            
            for (int i = 1; i <= int.parse(turma[1]); i++ ){
              var numero = '';
              if (i <= 9){
                numero = i.toString().padLeft(2,'0');
              }
              else{
                numero = i.toString();
              }
              var numero_aluno = numero + ".pt";
              String id_aluno = letras_escola + numero_aluno;
              alunos.add(id_aluno);
            
              DatabaseService().updateUserData(id_aluno, "idade", "genero", DateTime.now(), false, "idadeIngresso", "maisInfo", "nacionalidade", "nacionalidadeEE", "grauParentesco", "habilitacoesEE", "idadeEE", "profissaoEE", "profissaoMae", "idadeMae", "nacionalidadeMae", "habilitacoesMae", "idadePai", "nacionalidadePai", "profissaoPai", "habilitacoesPai",id_turma,id_escola);

              var password = generatePassword(true, true, true, false, 10);
       
              AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: id_aluno.trim(), password: password);
              var write = id_aluno + " -> " + password + "\n";
              file.writeAsStringSync(write, mode: FileMode.APPEND);
            }
            
            var fileExtension = path.extension(file.path);

            var uuid = Uuid().v4();

            var turmas_path = 'turmas/$uuid$fileExtension';
            final StorageReference firebaseStorageRef = FirebaseStorage.instance
                .ref()
                .child(turmas_path);

            await firebaseStorageRef
                .putFile(file)
                .onComplete
                .catchError((onError) {
              print(onError);
              return false;
            });



            

            //create turma
            DatabaseService().updateTurmaData(id_turma, turma[0], turma[2], int.parse(turma[1]), alunos, turmas_path);

          list_Turmas_id.add(id_turma);
        }



      }

      
      await getListEscolas(context);
   


      
      if (listEscolas != null){
      
        //create escola
        
        DatabaseService().updateEscolaData(id_escola, escolas[i], list_Turmas_id);
        
          list_Escolas_id.add(id_escola);
       
        
      }

    }


    await getListAventura(context);
   
    await getListHiostoria(context);
    
    
    if (listHistorias != null && listAventura !=null){
      //get id historia
      String id_historia = "";
      String capa_historia = "";
      for(Historia h in listHistorias){
        if (h.titulo == dropdownValue){
          id_historia = h.id;
          capa_historia = h.capa;
        }
      }


      //create AVENTURA
      List ids_a = [];
        for(Aventura a in listAventura){
          ids_a.add(int.parse(a.id));
        }
        ids_a.sort();
        var id_aventura = (ids_a.last + 1).toString();
        DatabaseService().updateAventuraData(id_aventura, id_historia, Timestamp.now(), _aventura_local, list_Escolas_id, user.email, _aventura_nome, capa_historia);
     

      //back to homepage
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)));
    }
    }
     
   }
      

    Future<void> getLists(BuildContext context) async{
      await getListAventura(context);
   
      await getListHiostoria(context);
    
      await getListEscolas(context);
      await getListTurmas(context);

      listDropdown = <String>["Historia"];
   
      if(listHistorias != null){
        for (Historia h in  listHistorias){                             
          listDropdown.add(h.titulo);
        } 
      }
   
      
    }

    void addNewFieldEscola(){
        final _formKeyEscola = GlobalKey<FormState>();
        //String escola;
        int counter = escola_counter;
        escola_counter++;

        
        //flags_escolas.add(false);
        setState((){
        listOfFields.add(
          Column(
            children: <Widget>[
              Form(
              key: _formKeyEscola,
              child:
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Escola não inserida';
                    }
                  },
                  onSaved: (input) => _escola = input,
                   decoration: new InputDecoration(
                            labelText: "Escola",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                  )),
              IconButton(
                icon: Icon(Icons.check),
               // color: flags_escolas[counter] ? Colors.blue : null, 
                onPressed: (){
                  addEscola(_formKeyEscola, counter);
                 // setState(() {
                  //  flags_escolas[counter] = true;
                  //});
                }),
              GestureDetector(
                                onTap: () {
                              addNewFieldTurma(counter); 
                                },
                                child: Container(
                                  width: 300,
                                  height: 50,
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
                                      'Adicionar Turma',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Amatic SC'),
                                  )),
                                ),
                              ),
            
          ],)
        );
        });
        posicoes.add([0]);
        posicoes_counter ++;
        
      }
    
    
    void addEscola(GlobalKey<FormState> _formKeyEscola, int counter) async {
      if(escolas.length == counter){
        if(_formKeyEscola.currentState.validate()){
          _formKeyEscola.currentState.save();
          escolas.add(_escola);
        }
      }else{
        if(_formKeyEscola.currentState.validate()){
        _formKeyEscola.currentState.save();
        setState(() {
        escolas[counter] = _escola;
        });
      }
      }
      
    
    }


  

   void addNewFieldTurma(int counter){
        final _formKeyTurma = GlobalKey<FormState>();
  
        int pos_turma = 0;
        int pos = 0;
        for (int i = 0 ; i < posicoes_counter; i++){
         
          pos += posicoes[i].length;
          if (i == counter){
            pos_turma = posicoes[i].length - 1;
            posicoes[i].add(1);
            break;
          }
        }
      
   
        if(pos > listOfFields.length){
      
          setState((){
        
        listOfFields.add(
          Column(
            children: <Widget> [
            Form(
          key: _formKeyTurma,
          child: Container(
            padding: const EdgeInsets.only(left: 100),
            child: 
            Column(children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Turma não inserida';
                }
              },
              onSaved: (input) => _turma = input,
               decoration: new InputDecoration(
                            labelText: "Turma",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              
              ),
              TextFormField(
              validator: (input) {
                 if (input.isEmpty) {
                      return 'Numero de alunos não inserido';
                    }
                    if(int.tryParse(input) == null) {
                      return 'Inserir numero inteiro';
                    }
              },
              onSaved: (input) => _nAlunos = input,
               decoration: new InputDecoration(
                            labelText: "Numero de alunos",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              ),
              TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Professor não inserido';
                }
              },
              onSaved: (input) => _professor = input,
               decoration: new InputDecoration(
                            labelText: "Professor",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              ),
          ],)
          
          )
          ),
                
          IconButton(icon: Icon(Icons.check), onPressed: (){addTurma(_formKeyTurma, counter, pos_turma);}),
              
          ]
          )
        );

        });
        }else{
       
          setState((){
        
        listOfFields.insert( pos,
             Column(
            children: <Widget> [
            Form(
          key: _formKeyTurma,
          child: Container(
            padding: const EdgeInsets.only(left: 100),
            child: 
            Column(children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Turma não inserida';
                }
              },
              onSaved: (input) => _turma = input,
               decoration: new InputDecoration(
                            labelText: "Turma",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              
              ),
              TextFormField(
              validator: (input) {
                 if (input.isEmpty) {
                      return 'Numero de alunos não inserido';
                    }
                    if(int.tryParse(input) == null) {
                      return 'Inserir numero inteiro';
                    }
              },
              onSaved: (input) => _nAlunos = input,
               decoration: new InputDecoration(
                            labelText: "Numero de alunos",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              ),
              TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Professor não inserido';
                }
              },
              onSaved: (input) => _professor = input,
               decoration: new InputDecoration(
                            labelText: "Professor",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
              ),
          ],)
          
          )
          ),
                
          IconButton(icon: Icon(Icons.check), onPressed: (){addTurma(_formKeyTurma, counter, pos_turma);}),
              
          ]
          ));

        });
        }





        
        
      }

     
    void addTurma(GlobalKey<FormState> _formKeyTurma, int counter, int pos_turma) async {
      if(turmas.length == counter){
        if(_formKeyTurma.currentState.validate()){
          _formKeyTurma.currentState.save();
          turmas.add([[_turma,_nAlunos,_professor]]);
          
        }
      }else{
        if(_formKeyTurma.currentState.validate()){
        _formKeyTurma.currentState.save();
        setState(() {
          if (turmas[counter].asMap().containsKey(pos_turma)){
            turmas[counter][pos_turma] = [_turma,_nAlunos,_professor];
          }else{
            turmas[counter].add([_turma,_nAlunos,_professor]);
          }
        });
      }
      }
      
     
    }




    Future<void> getListAventura(BuildContext context) async{
      listAventura = Provider.of<List<Aventura>>(context, listen: false);
    }
    Future<void> getListHiostoria(BuildContext context) async{
      listHistorias = Provider.of<List<Historia>>(context, listen: false);
    }
    Future<void> getListTurmas(BuildContext context) async{
      listTurmas = Provider.of<List<Turma>>(context, listen: false);
    }
    Future<void> getListEscolas(BuildContext context) async{
      listEscolas = Provider.of<List<Escola>>(context, listen: false);
    }

}