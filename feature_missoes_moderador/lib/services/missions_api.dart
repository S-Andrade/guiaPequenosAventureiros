import 'dart:io';
import 'dart:math';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/models/questionario.dart';
import 'package:feature_missoes_moderador/models/quiz.dart';
import 'package:feature_missoes_moderador/screens/turma/turma.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../notifier/missions_notifier.dart';
import '../models/mission.dart';
import '../models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// API FIRESTORE AND STORAGE FUNCTIONS FOR MISSIONS PAGE

/*
BUSCAR MISSOES
*/

/// BUSCAR TODAS AS MISSÕES NO FIRESTORE REFERENTES UM CAPITULO

MissionsNotifier missionNotifier;

getMissions(MissionsNotifier missionsNotifier, List missions) async {
  missionNotifier = missionsNotifier;

  List<Mission> _missionListFinal = [];

  missions.forEach((document) {
    document.get().then((missionSnapchot) {
      Mission mission = Mission.fromMap(missionSnapchot.data);
      if (mission.type == "Quiz") {
        DocumentReference quizReference = mission.content;
        quizReference.get().then((quizSnapshot) {
          if (quizSnapshot.exists) {
            Quiz quiz = Quiz.fromMap(quizSnapshot.data);
            quiz.id = quizReference;
            List<Question> questions = [];
            quiz.questions.forEach((questionReference) {
              DocumentReference question = questionReference;
              question.get().then((questionSnapshot) {
                if (questionSnapshot.exists) {
                  Question q = Question.fromMap(questionSnapshot.data);
                  questions.add(q);
                }
              });
            });
            quiz.questions = questions;
            mission.content = quiz;
            missionsNotifier.missionContent = quiz;
          }
        });
      } else if (mission.type == "Activity") {
        List<Activity> activities = [];

        DocumentReference activityReference;

        for (activityReference in mission.content) {
          activityReference.get().then((activitySnapshot) {
            if (activitySnapshot.exists) {
              Activity activity = Activity.fromMap(activitySnapshot.data);
              activities.add(activity);
            }
          });
          mission.content = activities;
          missionsNotifier.missionContent = activities;
        }
      } else if (mission.type == 'Questionario') {
        DocumentReference questionarioReference = mission.content;
        questionarioReference.get().then((qSnapshot) {
          if (qSnapshot.exists) {
            Questionario questionario = Questionario.fromMap(qSnapshot.data);
            questionario.id = questionarioReference;
            List<Question> questions = [];
            questionario.questions.forEach((questionReference) {
              DocumentReference question = questionReference;
              question.get().then((questionSnapshot) {
                if (questionSnapshot.exists) {
                  Question q = Question.fromMap(questionSnapshot.data);
                  questions.add(q);
                }
              });
            });
            questionario.questions = questions;
            mission.content = questionario;
            missionsNotifier.missionContent = questionario;
          }
        });
      } else {
        missionsNotifier.missionContent = null;
      }

      _missionListFinal.add(mission);
    });
  });

  missionsNotifier.missionsList = _missionListFinal;
}

//GET PERGUNTAS DOS QUESTIONARIOS(MULTIPLECHOICE=FALSE)
getQuestions(MissionsNotifier missionsNotifier) async {
  List<Question> _qList = [];
  List perguntas = [];
  QuerySnapshot result =
      await Firestore.instance.collection('question').getDocuments();
  List<DocumentSnapshot> documents = result.documents;
   documents.forEach((element) {
    Question question = Question.fromMap(element.data);
    if (question.multipleChoice == false){
      if(!perguntas.contains(question.question)){
        perguntas.add(question.question);
        _qList.add(question);
      }
    }
  });
  missionsNotifier.allQuestions=_qList;
}

// BUSCA TODAS AS MISSÕES EXISTENTES NA BASE DE DADOS, necessário para saber o id mais alto no momento

Future<List<Mission>> getAllMissionsInDatabase() async {
  List<Mission> _missionList = [];

  final QuerySnapshot result =
      await Firestore.instance.collection('mission').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  documents.forEach((element) {
    Mission mission = Mission.fromMap(element.data);
    _missionList.add(mission);
  });
  return _missionList;
}

/*

 CRIAÇÃO DE MISSÕES 

*/

// CRIAÇAO DE UMA MISSÃO DE TEXTO

createMissionTextInFirestore(String titulo, String conteudo, String aventuraId,
    String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  mission.title = titulo;
  mission.id = (_largerId + 1).toString();
  mission.content = conteudo;
  mission.type = 'Text';
  mission.resultados = [];

  alunos.forEach((element) {
    print(element);
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  CollectionReference missionRef = Firestore.instance.collection('mission');

  DocumentReference documentRef = missionRef.document(mission.id);

  documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

//CRIAR MISSÃO QUIZ
//CRIA AS PERGUNTAS
//CRIA UM QUIZ
//ASSOCIA A UMA MISSÃO
//ASSOCIA AO CAPITULO
createMissionQuiz(
    String titulo, List questoes, String aventuraId, String capituloId) async {
  List<dynamic> documentosQuestao = new List<dynamic>();
  CollectionReference questionRef = Firestore.instance.collection('question');

  var rng = new Random();

  for (Question q in questoes) {
    int index = (questoes.indexOf(q)) + 1;
    q.id = (rng.nextInt(1000) + rng.nextInt(1000) + index).toString();
    q.multipleChoice = true;

    DocumentReference documentRef = questionRef.document(q.id);

    await documentRef.setData(q.toMap());
    documentRef.updateData({
      'resultados': FieldValue.delete(),
      'answers': FieldValue.delete(),
      'respostaEscolhida': FieldValue.delete(),
    });

    documentosQuestao.add(documentRef);
  }

  CollectionReference quizRef = Firestore.instance.collection('quiz');

  Quiz quiz = new Quiz();
  quiz.questions = documentosQuestao;
  quiz.resultados = [];

  List<dynamic> alunos;
  alunos = await getAlunos(aventuraId);
  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['result'] = 0;
    quiz.resultados.add(mapa);
  });

  DocumentReference quizDocRef = await quizRef.add(quiz.toMap());

  Mission mission = new Mission();
  int _largerId;
  _largerId = await getMissionsLargerId();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.id = (_largerId + 1).toString();
  mission.title = titulo;
  mission.type = 'Quiz';
  mission.content = quizDocRef;
  mission.resultados = [];

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);
  await documentRef.setData(mission.toMap());
  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

//CRIAR MISSÃO QUESTIONARIO
//CRIA AS PERGUNTAS
//CRIA UM QUESTIONARIO
//ASSOCIA A UMA MISSÃO
//ASSOCIA AO CAPITULO
createMissionQuestinario(
    String titulo, List questoes, String aventuraId, String capituloId) async {
  print('a criaaaaaarrrrr questionario');
  List<dynamic> documentosQuestao = new List<dynamic>();
  CollectionReference questionRef = Firestore.instance.collection('question');

  var rng = new Random();
  List<dynamic> alunos;
  alunos = await getAlunos(aventuraId);
  List res = [];
  for (Question q in questoes) {
    print(q.question);
    int index = (questoes.indexOf(q)) + 1;
    q.id = (rng.nextInt(1000) + rng.nextInt(1000) + index).toString();
    q.multipleChoice = false;
    q.respostaEscolhida = "";
    alunos.forEach((element) {
      Map<String, dynamic> mapa = {};
      mapa['aluno'] = element;
      mapa['respostaEscolhida'] = "";
      mapa['respostaNumerica'] = 0;
      res.add(mapa);
    });

    DocumentReference documentRef = questionRef.document(q.id);
    q.resultados = res;
    await documentRef.setData(q.toMap());
    documentRef.updateData({
      'correct_answer': FieldValue.delete(),
      'done': FieldValue.delete(),
      'success': FieldValue.delete(),
      'wrong_answers': FieldValue.delete(),
    });
    documentosQuestao.add(documentRef);
  }

  CollectionReference questionarioRef =
      Firestore.instance.collection('questionario');

  Questionario questionario = new Questionario();
  questionario.questions = documentosQuestao;

  DocumentReference qDocRef = await questionarioRef.add(questionario.toMap());

  Mission mission = new Mission();
  int _largerId;
  _largerId = await getMissionsLargerId();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.id = (_largerId + 1).toString();
  mission.title = titulo;
  mission.type = 'Questionario';
  mission.content = qDocRef;
  mission.resultados = [];

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);
  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });
  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DE UMA MISSÃO ATIVIDADE
// PRIMEIRO CRIA SE OS DOCUMENTOS PARA CADA ATIVIDADE
// DEPOIS CRIA-SE A MISSÃO COM A LISTA DOS DOCUMENTOS DE ATIVIDADE
createMissionActivityInFirestore(String titulo, List<Activity> activities,
    String aventuraId, String capituloId) async {
  CollectionReference activityRef = Firestore.instance.collection('activity');

  List<dynamic> documentos = new List<dynamic>();

  var rng = new Random();

  for (Activity activity in activities) {
    int index = (activities.indexOf(activity)) + 1;
    activity.id = (rng.nextInt(1000) + rng.nextInt(1000) + index).toString();
    DocumentReference documentRef = activityRef.document(activity.id);
    await documentRef.setData(activity.toMap());
    documentos.add(documentRef);
  }

  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.id = (_largerId + 1).toString();
  mission.title = titulo;
  mission.type = 'Activity';
  mission.content = documentos;
  mission.resultados = [];

  alunos.forEach((element) {
    print(element);
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DA MISSÃO DE IMAGEM

createMissionImageInFirestore(String imageUrl, String titulo, String descricao,
    String aventuraId, String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (imageUrl != null) {
    mission.linkImage = imageUrl;
    mission.id = (_largerId + 1).toString();
    mission.title = titulo;
    mission.type = 'Image';
    mission.content = descricao;
    mission.resultados = [];
  }

  alunos.forEach((element) {
    print(element);
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DA MISSÃO DE VÍDEO

createMissionVideoInFirestore(String videoUrl, String titulo, String descricao,
    String aventuraId, String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (videoUrl != null) {
    mission.linkVideo = videoUrl;
    mission.id = (_largerId + 1).toString();
    mission.title = titulo;
    mission.type = 'Video';
    mission.resultados = [];
    mission.content = descricao;
  }

  alunos.forEach((element) {
    print(element);
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkAudio': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DA MISSÃO DE AUDIO

createMissionAudioInFirestore(String audioUrl, String titulo, String descricao,
    String aventuraId, String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (audioUrl != null) {
    mission.linkAudio = audioUrl;
    mission.id = (_largerId + 1).toString();
    mission.title = titulo;
    mission.type = 'Audio';
    mission.resultados = [];
    mission.content = descricao;
  }

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DA MISSÃO DE UPLOAD IMAGEM/VIDEO

createMissionUploadImageInFirestore(String titulo, String descricao,
    String aventuraId, String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (titulo != null && descricao != null) {
    mission.title = titulo;
    mission.id = (_largerId + 1).toString();
    mission.resultados = [];
    mission.content = descricao;
    mission.type = 'UploadImage';
  }

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mapa['linkUploaded'] = "";
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
    'linkAudio': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

createMissionUploadVideoInFirestore(String titulo, String descricao,
    String aventuraId, String capituloId) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (titulo != null && descricao != null) {
    mission.title = titulo;
    mission.id = (_largerId + 1).toString();
    mission.resultados = [];
    mission.content = descricao;
    mission.type = 'UploadVideo';
  }

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterVisited'] = 0;
    mapa['done'] = false;
    mapa['timeVisited'] = 0;
    mission.resultados.add(mapa);
  });

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

  documentRef.updateData({
    'linkVideo': FieldValue.delete(),
    'linkImage': FieldValue.delete(),
    'linkAudio': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

/* 
UPLOADS PARA O STORAGE DO FIREBASE
*/

// UPLOAD DA IMAGEM, OBTENÇÃO DO URL E CONSEQUENTE CRIAÇÃO DA MISSÃO

addUploadedImageToFirebaseStorage(String titulo, String descricao,
    File localFile, String aventuraId, String capituloId) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/moderadores/uploaded_images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String imageUrl = await firebaseStorageRef.getDownloadURL();

    createMissionImageInFirestore(
        imageUrl, titulo, descricao, aventuraId, capituloId);
  }
}

// UPLOAD DO AUDIO, OBTENÇÃO DO URL E CONSEQUENTE CRIAÇÃO DA MISSÃO

addUploadedAudioToFirebaseStorage(String titulo, String descricao,
    File localFile, String aventuraId, String capituloId) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/moderadores/uploaded_audios/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    createMissionAudioInFirestore(
        url, titulo, descricao, aventuraId, capituloId);
  }
}

// UPLOAD DO VIDEO, OBTENÇÃO DO URL E CONSEQUENTE CRIAÇÃO DA MISSÃO

addUploadedVideoToFirebaseStorage(String titulo, String descricao,
    File localFile, String aventuraId, String capituloId) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/moderadores/uploaded_videos/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    createMissionVideoInFirestore(
        url, titulo, descricao, aventuraId, capituloId);
  }
}

// APENAS UPLOAD DA IMAGEM E RETORNO DO URL , necessário para a criação das atividades

uploadImageToFirebaseStorage(File localFile) async {
  var fileExtension = path.extension(localFile.path);

  var uuid = Uuid().v4();

  final StorageReference firebaseStorageRef = FirebaseStorage.instance
      .ref()
      .child('mission/moderadores/uploaded_images/$uuid$fileExtension');

  await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
    print(onError);
    return false;
  });

  String imageUrl = await firebaseStorageRef.getDownloadURL();

  return imageUrl;
}

/*
FUNÇÕES AUXILIARES
*/

// ASSOCIA UMA MISSÃO NOVA CRIADA, AO CAPITULO DA HISTORIA ONDE ESTA APARECERÁ

attachMissionToCapitulo(dynamic mission, String capituloId) async {
  CollectionReference capituloRef = Firestore.instance.collection('capitulo');

  await capituloRef.document(capituloId).updateData({
    'missoes': FieldValue.arrayUnion([mission])
  });
}

// REMOVE MISSAO ESPECIFICA E DESASSOCIA DO CAPITULO A QUE PERTENCE

deleteMissionInFirestore(Mission mission, String capituloId) async {
  if (mission.type == "Activity") {
    for (Activity a in mission.content) {
      CollectionReference activityRef =
          Firestore.instance.collection('activity');

      await activityRef.document(a.id).delete();
    }
  }

  CollectionReference missionRef = Firestore.instance.collection('mission');
  DocumentReference documentRef = missionRef.document(mission.id);
  print("missiooon" + mission.id);

  CollectionReference capituloRef = Firestore.instance.collection('capitulo');
  DocumentReference documentRef2 = capituloRef.document(capituloId);

  var capituloDoc = [];
  capituloDoc.add(documentRef);
  print(documentRef.toString());
  await documentRef2.updateData({
    "missoes": FieldValue.arrayRemove(capituloDoc),
  });

  await documentRef.delete();
}

// RETORNA UMA LISTA DE IDS DE TURMAS ASSOCIADAS A UM CAPITULO

getTurmas(String aventuraId) async {
  List<dynamic> escolas = [];
  List<dynamic> turmas = [];
  List<dynamic> listaTurmas = [];
  List<Turma> finalTurmas = [];

  List<dynamic> turmasAll = [];

  await Firestore.instance
      .collection('aventura')
      .where('id', isEqualTo: aventuraId)
      .getDocuments()
      .then((doc) {
    escolas = doc.documents[0]['escolas'];
  });

  for (var id_escola in escolas) {
    List<dynamic> turmasDoc = await Firestore.instance
        .collection('escola')
        .where('id', isEqualTo: id_escola)
        .getDocuments()
        .then((doc) {
      turmas = doc.documents[0]['turmas'];
    });

    for (var turmaId in turmas) {
      listaTurmas.add(turmaId);
    }
  }
  return listaTurmas;
}

/*
getTurma(String turmaId) async {

 DocumentReference documentReference =
          Firestore.instance.collection("turma").document(turmaId);
           
      await documentReference.get().then((datasnapshot) {
        
        if (datasnapshot.exists) {
          setState(() {
         turma = new Turma(
              id: datasnapshot.data['id'] ?? '',
              nAlunos: datasnapshot.data['nAlunos'] ?? null,
              file: datasnapshot.data['file'] ?? '',
              professor: datasnapshot.data['professor'] ?? '',
              alunos: datasnapshot.data['alunos'] ?? []);
            
       });
        }
        
      });

      
     
      

  

}
*/

// RETORNA UMA LISTA DE ALUNOS DE TODAS AS TURMAS ASSOCIADAS À ESCOLA QUE ESTÁ ASSOCIADADA A UMA DADA AVENTURA

getAlunos(String aventuraId) async {
  List<dynamic> escolas = [];
  List<dynamic> turmas = [];
  List<dynamic> listaTurmas = [];
  List<dynamic> alunos = [];
  List<dynamic> listaAlunos = [];

  await Firestore.instance
      .collection('aventura')
      .where('id', isEqualTo: aventuraId)
      .getDocuments()
      .then((doc) {
    escolas = doc.documents[0]['escolas'];
  });

  for (var id_escola in escolas) {
    await Firestore.instance
        .collection('escola')
        .where('id', isEqualTo: id_escola)
        .getDocuments()
        .then((doc) {
      turmas = doc.documents[0]['turmas'];
    });
    print("turmas");
    for (var turma in turmas) listaTurmas.add(turma);
  }

  for (var id_turma in listaTurmas) {
    await Firestore.instance
        .collection('turma')
        .where('id', isEqualTo: id_turma)
        .getDocuments()
        .then((doc) {
      alunos = doc.documents[0]['alunos'];
    });
    print("alunos");
    for (var aluno in alunos) listaAlunos.add(aluno);
  }

  return listaAlunos;
}

// RETORNA ALUNOS DE UMA TURMA

getAlunosForTurma(String turmaId) async {
  List<dynamic> alunos = [];
  await Firestore.instance
      .collection('turma')
      .where('id', isEqualTo: turmaId)
      .getDocuments()
      .then((doc) {
    alunos = doc.documents[0]['alunos'];
  });

  return List<String>.from(alunos);
}

// RETORNA MISSOES DE UM CERTO CAPITULO

getMissionsForCapitulo(String capituloId) async {
  List<dynamic> missions = [];
  Mission mission;
  List<dynamic> missionsIds = [];

  await Firestore.instance
      .collection('capitulo')
      .where('id', isEqualTo: capituloId)
      .getDocuments()
      .then((doc) {
    missions = doc.documents[0]['missoes'];
  });

  for (var missao in missions) {
    await missao.get().then((missionSnapchot) {
      if (missionSnapchot.exists) {
        mission = Mission.fromMap(missionSnapchot.data);
      } else {
        print("no data");
        mission = null;
      }
      missionsIds.add(mission);
    });
  }

  return List<Mission>.from(missionsIds);
}

// RETORNA QUANTAS MISSÕES DE UMA CERTA LISTA DE MISSÕES, JÁ FEZ UMA CERTA TURMA ( COM UM CERTO Nº DE ALUNOS )

int getDonesForTurma(List<String> alunos, List<Mission> missions) {
  int missionsDone = 0;

  for (var mission in missions) {
    for (var aluno in alunos) {
      for (var campo in mission.resultados) {
        if (campo['aluno'] == aluno) {
          if (campo['done'] == true) missionsDone++;
          break;
        }
      }
    }
  }

  return missionsDone;
}

// RETORNA O ID MAIS ALTO DE TODAS AS MISSOES NO FIRESTORE

getMissionsLargerId() async {
  List<Mission> _missionList = [];

  _missionList = await getAllMissionsInDatabase();

  int _largerId = 0;

  for (Mission m in _missionList) {
    int _idNumber = int.parse(m.id);
    if (_idNumber > _largerId) {
      _largerId = _idNumber;
    }
  }

  print("ID:" + _largerId.toString());

  return _largerId;
}
