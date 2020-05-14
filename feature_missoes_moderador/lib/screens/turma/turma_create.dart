import 'package:flutter/material.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import '../escola/escola.dart';
import '../escola/escola_details.dart';
import 'turma.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/password_generator.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';




class TurmaCreate extends StatefulWidget {
  
  Escola escola;
  TurmaCreate({this.escola});


  @override
  _TurmaCreate createState() => _TurmaCreate(escola: escola);
}

class _TurmaCreate extends State<TurmaCreate> {

  Escola escola;
  _TurmaCreate({this.escola});

  final _formKey = GlobalKey<FormState>();

 
  
  List<Turma> listTurmas;

  String nome;
  String nAlunos;
  String professor;
 

  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider<List<Turma>>.value(value: DatabaseService().turma),
      ],
      child: Builder(
        builder: (BuildContext context) { 
          return FutureBuilder<void>(
            future: getLists(context),
            builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            appBar: new AppBar(title: new Text("Criar turmas")),
             body:Form(
              key: _formKey,
              child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                    Center(
                      child: Container(
                        width: 600,
                        //height: 300,
                        padding: const EdgeInsets.only(top: 100),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                        
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da turma não inserido';
                            }
                          },
                          onSaved: (input) => nome = input,
                          decoration: new InputDecoration(
                            labelText: "Nome da turma",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                                  )
                    )
                    ),
                    Center(
                      child: Container(
                        width: 600,
                        //height: 300,
                        padding: const EdgeInsets.only(top: 50),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                        
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Numero de alunos não inserido';
                            }
                          },
                          onSaved: (input) => nAlunos = input,
                          decoration: new InputDecoration(
                            labelText: "Numero de alunos",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                                  )
                    )
                    ),
                    Center(
                      child: Container(
                        width: 600,
                      //  height: 300,
                        padding: const EdgeInsets.only(top: 50, bottom: 100),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style:TextStyle(fontSize: 30,fontFamily: 'Amatic SC',letterSpacing: 4),
                        
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome do professor não inserido';
                            }
                          },
                          onSaved: (input) => professor = input,
                          decoration: new InputDecoration(
                            labelText: "Nome do professor",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                                  )
                    )
                    ),
                           GestureDetector(
                            
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
                              )
                ]
            )
             )
          ));
            }); 
        }
       ));
  }

  Future<void> create(BuildContext context) async {

     if(_formKey.currentState.validate()){
        _formKey.currentState.save();

         await getListTurmas(context);
    print(listTurmas);



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
      var in_escolas =  escola.nome.substring(0,3).toLowerCase().trim()+ nome ;
      var letras_escola = in_escolas+ "@";


      var file_name = in_escolas + ".txt";

      final directory = await getApplicationDocumentsDirectory();
      final p = directory.path;

      
      File file = await new File('$p/$file_name');
      
      print(letras_escola);
      for (int i = 1; i <= int.parse(nAlunos); i++ ){
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
       
        DatabaseService().updateUserData(id_aluno, "idade", "genero", DateTime.now(), false, "idadeIngresso", "maisInfo", "nacionalidade", "nacionalidadeEE", "grauParentesco", "habilitacoesEE", "idadeEE", "profissaoEE", "profissaoMae", "idadeMae", "nacionalidadeMae", "habilitacoesMae", "idadePai", "nacionalidadePai", "profissaoPai", "habilitacoesPai", id_turma,escola.id);

        var password = generatePassword(true, true, true, false, 10);
        print(id_aluno + " -> " + password);
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
      DatabaseService().updateTurmaData(id_turma, nome, professor, int.parse(nAlunos), alunos, turmas_path);


      //gerar alunos
      List turmas = [];
      turmas = escola.turmas;
      turmas.add(id_turma);
      print(turmas);
      DatabaseService().updateEscolaData(escola.id, escola.nome, turmas);


      //back to homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) => EscolaDetails(escola: escola)));

    }

     }

   
    
  }

  
    Future<void> getLists(BuildContext context) async{
      await getListTurmas(context);
      print(listTurmas);
      
    }
    Future<void> getListTurmas(BuildContext context) async{
      listTurmas = Provider.of<List<Turma>>(context, listen: false);
    }
    

}