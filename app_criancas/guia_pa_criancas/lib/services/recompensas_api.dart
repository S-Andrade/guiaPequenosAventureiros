import 'dart:math';

import 'package:app_criancas/models/cromos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//Funções para o ranking -------

//FUNÇÕES DE UPDATE
updatePontuacao(String aluno, int pontuacao) async {
  String cromo_aluno = await updatePontuacaoAluno(aluno, pontuacao);
  String cromo_turma = await updatePontuacaoTurma(aluno, pontuacao);
  return [cromo_aluno,cromo_turma];
}

updatePontuacaoAluno(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoAluno(aluno);
  print('pontuacaooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
  print(pontos);
  int novaPontuacao = pontos + pontuacao;
  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);
  await alunoDocRef.updateData({'pontuacao': novaPontuacao});
  String cromo = null;
  if(novaPontuacao % 100 == 0){
    cromo = await giveCromoAluno(aluno);
  }
  return cromo;
}

updatePontuacaoTurma(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoTurma(aluno);
  int novaPontuacao = pontos + pontuacao;
  String turma = await getAlunoTurma(aluno);
  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);
  await turmaDocRef.updateData({'pontuacao': novaPontuacao});
  String cromo;
  if(novaPontuacao % 1000 == 0){
    cromo = await giveCromoTurma(turma);
  }
  return cromo;
}

//FUNÇÕES DE GET

getPontuacaoAluno(String aluno) async {
  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);
  int p = await alunoDocRef.get().then((snapshot) {
    int pont = snapshot.data['pontuacao'];
    return pont;
  });
  return p;
}

getPontuacaoTurma(String aluno) async {
  String turma = await getAlunoTurma(aluno);
  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);
  int p = await turmaDocRef.get().then((snapshot) {
    int pont = snapshot.data['pontuacao'];
    return pont;
  });
  return p;
}

//Função auxiliar

getAlunoTurma(String aluno) async {
  CollectionReference companheiroRef = Firestore.instance.collection('aluno');
  DocumentReference companheiroDocRef = companheiroRef.document(aluno);
  String turma = await companheiroDocRef.get().then((snapshot) {
    String c = snapshot.data['turma'];
    return c;
  });
  return turma;
}

//FUNCOES PARA OS COLECIONAVEIS

giveCromoAluno(String aluno) async {
  List cromos = await getCromosAluno();

  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);

  List cromos_aluno = await alunoDocRef.get().then((snapshot) {
    List c = snapshot.data['cromos'];
    return c;
  });

  if(cromos.length != cromos_aluno.length){
    String novo_cromo = cromos[Random().nextInt(cromos.length)];
    while(cromos_aluno.contains(novo_cromo)){
      cromos.remove(novo_cromo);
      novo_cromo = cromos[Random().nextInt(cromos.length)];
    }

    cromos_aluno.add(novo_cromo);

    await alunoDocRef.updateData({'cromos': cromos_aluno});
    return "cromos/aluno/$novo_cromo";
  }
  return null;
}

giveCromoTurma(String turma) async {
  List cromos = await getCromosTurma();

  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);

  List cromos_turma = await turmaDocRef.get().then((snapshot) {
    List c = snapshot.data['cromos'];
    return c;
  });

  if(cromos.length != cromos_turma.length){
    String novo_cromo = cromos[Random().nextInt(cromos.length)];
    while(cromos_turma.contains(novo_cromo)){
      cromos.remove(novo_cromo);
      novo_cromo = cromos[Random().nextInt(cromos.length)];
    }

    cromos_turma.add(novo_cromo);

    await turmaDocRef.updateData({'cromos': cromos_turma});
    return "cromos/turma/$novo_cromo";
  }
  return null;

}


getCromosAluno() async{
  List list_cromos;
  DocumentReference documentReference = Firestore.instance.collection("cromos").document("cromos"); 
  await documentReference.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      Cromos cromos = Cromos(
        aluno: datasnapshot.data['aluno'] ?? [],
        turma: datasnapshot.data['turma'] ?? []
      );
      list_cromos = cromos.aluno;
    }
    else{
      print("La se foram os cromos");
    }
  });
  return list_cromos;
}



getCromosTurma() async{
  List list_cromos;
  DocumentReference documentReference = Firestore.instance.collection("cromos").document("cromos"); 
  await documentReference.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      Cromos cromos = Cromos(
        aluno: datasnapshot.data['aluno'] ?? [],
        turma: datasnapshot.data['turma'] ?? []
      );
      list_cromos = cromos.turma;
    }
    else{
      print("La se foram os cromos");
    }
  });
  return list_cromos;
}
