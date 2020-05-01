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

  final myControllerNome = TextEditingController();
  final myControllerNAlunos = TextEditingController();
  final myControllerProfessor = TextEditingController();
  
  List<Turma> listTurmas;
 

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerNome.dispose();
    myControllerProfessor.dispose();
    myControllerNAlunos.dispose();
    super.dispose();
  }

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
              child: Column(
                children: <Widget>[
                      TextFormField(
                        controller: myControllerNome,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome da Turma não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Nome da Turma   '
                          )),
                          TextFormField(
                        controller: myControllerNAlunos,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Numero de alunos não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Numero de alunos   '
                          )),
                          TextFormField(
                        controller: myControllerProfessor,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Nome do professor não inserido';
                            }
                          },
                         
                          decoration: InputDecoration(
                            hintText: 'Nome do professor  '
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

    await getListTurmas(context);
    print(listTurmas);

    List alunos = [];
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    if (listTurmas != null){
      //gerar alunos
      var in_escolas =  escola.nome.substring(0,3).toLowerCase().trim()+ myControllerNome.text ;
      var letras_escola = in_escolas+ "@";


      var file_name = in_escolas + ".txt";

      final directory = await getApplicationDocumentsDirectory();
      final p = directory.path;

      
      File file = await new File('$p/$file_name');
      
      print(letras_escola);
      for (int i = 1; i <= int.parse(myControllerNAlunos.text); i++ ){
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
       
        DatabaseService().updateUserData(id_aluno, "idade", "genero", DateTime.now(), false, "idadeIngresso", "maisInfo", "nacionalidade", "nacionalidadeEE", "grauParentesco", "habilitacoesEE", "idadeEE", "profissaoEE", "profissaoMae", "idadeMae", "nacionalidadeMae", "habilitacoesMae", "idadePai", "nacionalidadePai", "profissaoPai", "habilitacoesPai");

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



      List ids_t = [];
      for (Turma t in listTurmas){
        int d = int.parse(t.id, onError: (e) => null);
        if (d != null){
          ids_t.add(int.parse(t.id));
        }
        
      }
      ids_t.sort();
      var id_turma = (ids_t.last + 1).toString();

      //create turma
      DatabaseService().updateTurmaData(id_turma, myControllerNome.text, myControllerProfessor.text, int.parse(myControllerNAlunos.text), alunos, turmas_path);


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

  
    Future<void> getLists(BuildContext context) async{
      await getListTurmas(context);
      print(listTurmas);
      
    }
    Future<void> getListTurmas(BuildContext context) async{
      listTurmas = Provider.of<List<Turma>>(context, listen: false);
    }
    

}