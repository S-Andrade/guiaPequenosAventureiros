import 'dart:math';
import 'package:app_criancas/models/cromos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Funções para o ranking -------

//FUNÇÕES DE UPDATE

updatePontuacao(String aluno, int pontuacao) async {
  List cromoAluno = await updatePontuacaoAluno(aluno, pontuacao);
  print("aluno");
  print(cromoAluno);
  List cromoTurma = await updatePontuacaoTurma(aluno, pontuacao);
  print("turma");
  print(cromoTurma);
  List r = [];
  r.add(cromoAluno);
  r.add(cromoTurma);
  return r;
}

updatePontuacaoAluno(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoAluno(aluno);
  int novaPontuacao = pontos + pontuacao;
  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);
  await alunoDocRef.updateData({'pontuacao': novaPontuacao});
  int nCromos = howMany(100, pontos, novaPontuacao);
  print(nCromos);
  List c = [];
  for(int i = 0 ; i < nCromos; i++){
    c.add( await giveCromoAluno(aluno));
  }
  return c;
}

updatePontuacaoTurma(String aluno, int pontuacao) async {
  int pontos = await getPontuacaoTurma(aluno);
  int novaPontuacao = pontos + pontuacao;
  String turma = await getAlunoTurma(aluno);
  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);
  await turmaDocRef.updateData({'pontuacao': novaPontuacao});
  int nCromos = howMany(1000, pontos, novaPontuacao);
  List c = [];
  for(int i = 0 ; i < nCromos; i++){
    c.add(await giveCromoTurma(aluno));
  }
  return c;
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

//Função auxiliar-------------

getAlunoTurma(String aluno) async {
  CollectionReference companheiroRef = Firestore.instance.collection('aluno');
  DocumentReference companheiroDocRef = companheiroRef.document(aluno);
  String turma = await companheiroDocRef.get().then((snapshot) {
    String c = snapshot.data['turma'];
    return c;
  });
  return turma;
}


howMany(int element, int min, int max){
  List solutions = [];
  for (int i = min+1; i <= max; i++){
    if(i % element == 0){
      solutions.add(i);
    }
  }
 return solutions.length;
}

giveCromoAluno(String aluno) async {
  List cromos = await getCromosAluno();

  CollectionReference alunoRef = Firestore.instance.collection('aluno');
  DocumentReference alunoDocRef = alunoRef.document(aluno);

  List cromosAluno = await alunoDocRef.get().then((snapshot) {
    List c = snapshot.data['cromos'];
    return c;
  });

  if (cromos.length != cromosAluno.length) {
    String novoCromo = cromos[Random().nextInt(cromos.length)];
    while (cromosAluno.contains(novoCromo)) {
      cromos.remove(novoCromo);
      novoCromo = cromos[Random().nextInt(cromos.length)];
    }

    cromosAluno.add(novoCromo);

    await alunoDocRef.updateData({'cromos': cromosAluno});
    return "cromos/aluno/$novoCromo";
  }
  return null;
}

giveCromoTurma(String turma) async {
  List cromos = await getCromosTurma();

  CollectionReference turmaRef = Firestore.instance.collection('turma');
  DocumentReference turmaDocRef = turmaRef.document(turma);

  List cromosTurma = await turmaDocRef.get().then((snapshot) {
    List c = snapshot.data['cromos'];
    return c;
  });

  if (cromos.length != cromosTurma.length) {
    String novoCromo = cromos[Random().nextInt(cromos.length)];
    while (cromosTurma.contains(novoCromo)) {
      cromos.remove(novoCromo);
      novoCromo = cromos[Random().nextInt(cromos.length)];
    }

    cromosTurma.add(novoCromo);

    await turmaDocRef.updateData({'cromos': cromosTurma});
    return "cromos/turma/$novoCromo";
  }
  return null;
}

//Funções para ir buscar a lista de cromos existentes-----------

getCromosAluno() async {
  List listCromos;
  DocumentReference documentReference =
      Firestore.instance.collection("cromos").document("cromos");
  await documentReference.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      Cromos cromos = Cromos(
          aluno: datasnapshot.data['aluno'] ?? [],
          turma: datasnapshot.data['turma'] ?? []);
      listCromos = cromos.aluno;
    } else {
      print("La se foram os cromos");
    }
  });
  return listCromos;
}

getCromosTurma() async {
  List listCromos;
  DocumentReference documentReference =
      Firestore.instance.collection("cromos").document("cromos");
  await documentReference.get().then((datasnapshot) async {
    if (datasnapshot.exists) {
      Cromos cromos = Cromos(
          aluno: datasnapshot.data['aluno'] ?? [],
          turma: datasnapshot.data['turma'] ?? []);
      listCromos = cromos.turma;
    } else {
      print("La se foram os cromos");
    }
  });
  return listCromos;
}

