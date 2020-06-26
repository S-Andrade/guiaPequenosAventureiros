import 'dart:math';
import 'package:app_criancas/models/cromos.dart';
import 'package:app_criancas/screens/aventura/aventura.dart';
import 'package:app_criancas/services/missions_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_criancas/screens/turma/turma.dart';

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
  for (int i = 0; i < nCromos; i++) {
    c.add(await giveCromoAluno(aluno));
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
  for (int i = 0; i < nCromos; i++) {
    c.add(await giveCromoTurma(turma));
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
  print("aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
  print(turma);
  return turma;
}

howMany(int element, int min, int max) {
  List solutions = [];
  for (int i = min + 1; i <= max; i++) {
    if (i % element == 0) {
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

//-----outras funções

getAllTurmasPontuacao(Aventura aventura) async {
  List escolas = aventura.escolas;
  List turmas = [];
  for (String e in escolas) {
    DocumentReference escola =
        Firestore.instance.collection('escola').document(e);
    await escola.get().then((turma) {
      turmas.addAll(turma.data['turmas']);
    });
  }
  final QuerySnapshot turmaRef =
      await Firestore.instance.collection('turma').getDocuments();
  print(turmas);
  List listaTurmas = turmaRef.documents.toList();
  List<Turma> temp = [];
  listaTurmas.forEach((doc) {
    Turma t = Turma(
        id: doc.data['id'] ?? '',
        professor: doc.data['professor'] ?? '',
        nAlunos: doc.data['nAlunos'] ?? 0,
        alunos: doc.data['alunos'] ?? [],
        nome: doc.data['nome'] ?? "",
        pontuacao: doc.data['pontuacao'] ?? 0,
        cromos: doc.data['cromos'] = []);
    if (turmas.contains(t.id)) {
      temp.add(t);
    }
    return temp;
  });
  return temp;
}

getUserCromos(String email) async {
  List cromos = [];
  DocumentReference alunoRef =
      Firestore.instance.collection('aluno').document(email);
  await alunoRef.get().then((value) {
    cromos = value.data['cromos'];
  });
  return cromos;
}

getUserTurmaCromos(String email) async {
  List cromos = [];
  DocumentReference alunoRef =
      Firestore.instance.collection('aluno').document(email);
  await alunoRef.get().then((value) async {
    String turma = value.data['turma'];
    DocumentReference turmaRef =
        Firestore.instance.collection('turma').document(turma);
    await turmaRef.get().then((value) {
      cromos = value.data['cromos'];
    });
  });
  return cromos;
}
