import 'package:cloud_firestore/cloud_firestore.dart';

//Funções para o ranking -------

//FUNÇÕES DE UPDATE

updatePontuacaoAluno(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoAluno(aluno);
  print('pontuacaooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
  print(pontos);
  int novaPontuacao = pontos + pontuacao;
  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);
  await alunoDocRef.updateData({'pontuacao': novaPontuacao});
}

updatePontuacaoTurma(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoTurma(aluno);
  int novaPontuacao = pontos + pontuacao;
  String turma = await getAlunoTurma(aluno);
  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);
  await turmaDocRef.updateData({'pontuacao': novaPontuacao});
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


//FUNCAO PARA VER QUANTOS PONTOS GANHA NESSA MISSAO
getPontosMissao(){}