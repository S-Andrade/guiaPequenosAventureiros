import 'dart:io';
import 'dart:math';
import 'package:feature_missoes_moderador/models/aluno.dart';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/models/questionario.dart';
import 'package:feature_missoes_moderador/models/quiz.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
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
    if (question.multipleChoice == false) {
      if (!perguntas.contains(question.question)) {
        perguntas.add(question.question);
        _qList.add(question);
      }
    }
  });
  missionsNotifier.allQuestions = _qList;
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

Future<List<String>> getAllQuizInDatabase() async {
  List<String> _idList = [];
  final QuerySnapshot result =
      await Firestore.instance.collection('quiz').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  documents.forEach((element) {
    _idList.add(element.documentID);
  });
  return _idList;
}

Future<List<String>> getAllQuestionarioInDatabase() async {
  List<String> _idList = [];
  final QuerySnapshot result =
      await Firestore.instance.collection('questionario').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  documents.forEach((element) {
    _idList.add(element.documentID);
  });
  return _idList;
}

Future<List<Activity>> getAllActivitiesInDatabase() async {
  List<Activity> _aList = [];

  final QuerySnapshot result =
      await Firestore.instance.collection('activity').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  documents.forEach((element) {
    Activity a = Activity.fromMap(element.data);
    _aList.add(a);
  });
  return _aList;
}

/*

 CRIAÇÃO DE MISSÕES 

*/

// CRIAÇAO DE UMA MISSÃO DE TEXTO

createMissionTextInFirestore(String titulo, String conteudo, String aventuraId,
    String capituloId, int pontos) async {
  Mission mission = new Mission();
  List<dynamic> alunos;
  int _largerId;

  _largerId = await getMissionsLargerId();
  alunos = await getAlunos(aventuraId);

  mission.title = titulo;
  mission.points = pontos;
  mission.id = (_largerId + 1).toString();
  mission.content = conteudo;
  mission.type = 'Text';
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
createMissionQuiz(String titulo, List questoes, String aventuraId,
    String capituloId, int pontos) async {
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
  int _largerIdQ = await getQuizLargerId();
  String qID = (_largerIdQ + 1).toString();

  List<dynamic> alunos;
  alunos = await getAlunos(aventuraId);
  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['result'] = 0;
    quiz.resultados.add(mapa);
  });

  DocumentReference quizDocRef = quizRef.document(qID);
  await quizDocRef.setData(quiz.toMap());

  Mission mission = new Mission();
  int _largerId;
  _largerId = await getMissionsLargerId();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.id = (_largerId + 1).toString();
  mission.title = titulo;
  mission.type = 'Quiz';
  mission.points = pontos;
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
createMissionQuestinario(String titulo, List questoes, String aventuraId,
    String capituloId, int pontos) async {
  List<dynamic> documentosQuestao = new List<dynamic>();
  CollectionReference questionRef = Firestore.instance.collection('question');

  var rng = new Random();
  List<dynamic> alunos;
  alunos = await getAlunos(aventuraId);
  List res = [];
  int _largerIdQ = await getQuestionarioLargerId();
  String qID = (_largerIdQ + 1).toString();

  for (Question q in questoes) {
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

  DocumentReference qDocRef =  questionarioRef.document(qID);
  await qDocRef.setData(questionario.toMap());

  Mission mission = new Mission();
  int _largerId;
  _largerId = await getMissionsLargerId();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.id = (_largerId + 1).toString();
  mission.title = titulo;
  mission.type = 'Questionario';
  mission.content = qDocRef;
  mission.resultados = [];
  mission.points = pontos;

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
    String aventuraId, String capituloId, int pontos) async {
  CollectionReference activityRef = Firestore.instance.collection('activity');

  List<dynamic> documentos = new List<dynamic>();

  int _largerIdAct = await getActivitiesLargerId();
  int index = 1;
  for (Activity activity in activities) {
    activity.id = (_largerIdAct + index).toString();
    DocumentReference documentRef = activityRef.document(activity.id);
    await documentRef.setData(activity.toMap());
    documentos.add(documentRef);
    index++;
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
  mission.points = pontos;
  mission.content = documentos;
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

// CRIAÇÃO DA MISSÃO DE IMAGEM

createMissionImageInFirestore(String imageUrl, String titulo, String descricao,
    String aventuraId, String capituloId, int pontos) async {
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
    mission.points = pontos;
    mission.content = descricao;
    mission.resultados = [];
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
    'linkAudio': FieldValue.delete(),
    'linkVideo': FieldValue.delete(),
  });

  attachMissionToCapitulo(documentRef, capituloId);
}

// CRIAÇÃO DA MISSÃO DE VÍDEO

createMissionVideoInFirestore(String videoUrl, String titulo, String descricao,
    String aventuraId, String capituloId, int pontos) async {
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
    mission.points = pontos;
    mission.resultados = [];
    mission.content = descricao;
  }

  alunos.forEach((element) {
    Map<String, dynamic> mapa = {};
    mapa['aluno'] = element;
    mapa['counter'] = 0;
    mapa['counterPause'] = null;
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
    String aventuraId, String capituloId, int pontos) async {
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
    mission.points = pontos;
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
    String aventuraId, String capituloId, int pontos) async {
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
    mission.points = pontos;
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
    String aventuraId, String capituloId, int pontos) async {
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
    mission.points = pontos;
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
    File localFile, String aventuraId, String capituloId, int pontos) async {
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
      return false;
    });

    String imageUrl = await firebaseStorageRef.getDownloadURL();

    createMissionImageInFirestore(
        imageUrl, titulo, descricao, aventuraId, capituloId, pontos);
  }
}

// UPLOAD DO AUDIO, OBTENÇÃO DO URL E CONSEQUENTE CRIAÇÃO DA MISSÃO

addUploadedAudioToFirebaseStorage(String titulo, String descricao,
    File localFile, String aventuraId, String capituloId, int pontos) async {
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
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    createMissionAudioInFirestore(
        url, titulo, descricao, aventuraId, capituloId, pontos);
  }
}

// UPLOAD DO VIDEO, OBTENÇÃO DO URL E CONSEQUENTE CRIAÇÃO DA MISSÃO

addUploadedVideoToFirebaseStorage(String titulo, String descricao,
    File localFile, String aventuraId, String capituloId, int pontos) async {
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
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    createMissionVideoInFirestore(
        url, titulo, descricao, aventuraId, capituloId, pontos);
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
  List<Question> questions = missionNotifier.allQuestions;
  if (mission.type == "Activity") {
    for (Activity a in mission.content) {
      CollectionReference activityRef =
          Firestore.instance.collection('activity');
      await activityRef.document(a.id).delete();
    }
  } else if (mission.type == "Questionario") {
    Questionario questionario = mission.content;
    questionario.questions.forEach((question) {
      Question q = question;
      questions.forEach((quest) async {
        if (quest.question == q.question) {
          CollectionReference activityRef =
              Firestore.instance.collection('question');
          await activityRef.document(q.id).delete();
        }
      });
    });
    await questionario.id.delete();
  } else if (mission.type == "Quiz") {
    Quiz quiz = mission.content;
    quiz.questions.forEach((question) async {
      Question q = question;
      CollectionReference activityRef =
          Firestore.instance.collection('question');
      await activityRef.document(q.id).delete();
    });
    await quiz.id.delete();
  }

  CollectionReference missionRef = Firestore.instance.collection('mission');
  DocumentReference documentRef = missionRef.document(mission.id);

  CollectionReference capituloRef = Firestore.instance.collection('capitulo');
  DocumentReference documentRef2 = capituloRef.document(capituloId);

  var capituloDoc = [];
  capituloDoc.add(documentRef);

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

  return _largerId;
}

getQuizLargerId() async {
  List<String> _quizList = [];
  _quizList = await getAllQuizInDatabase();
  int _largerId = 0;

  _quizList.forEach((element) {

    int _idNumber = int.parse(element);
   
    if (_idNumber > _largerId) {
      _largerId = _idNumber;
    }
  });
  return _largerId;
}

getQuestionarioLargerId() async {
  List<String> _qList = [];
  _qList = await getAllQuestionarioInDatabase();
  int _largerId = 0;

  _qList.forEach((element) {
  
    int _idNumber = int.parse(element);
   
    if (_idNumber > _largerId) {
      _largerId = _idNumber;
    }
  });
  return _largerId;
}

getActivitiesLargerId() async {
  List<Activity> _aList = [];

  _aList = await getAllActivitiesInDatabase();

  int _largerId = 0;

  if (_aList.length != 0) {
    for (Activity a in _aList) {
      int _idNumber = int.parse(a.id);
      if (_idNumber > _largerId) {
        _largerId = _idNumber;
      }
    }
  }

  return _largerId;
}

// RETORNA UMA INSTÂNCIA DO QUIZ DE UMA DADA MISSÃO DO TIPO QUIZ

getQuiz(content) async {
  DocumentReference quizReference = content;

  Quiz quiz;

  await quizReference.get().then((quizSnapshot) {
    if (quizSnapshot.exists) {
      quiz = Quiz.fromMap(quizSnapshot.data);
    } else
      print("bad");
  });

  return quiz;
}

// RETORNA UMA LISTA DE INSTÃNCIA DE PERGUNTAS DE UM QUESTIONARIO

getPerguntasDoQuestionario(content) async {
  DocumentReference questionarioReference = content;

  Questionario questionario;

  await questionarioReference.get().then((questionarioSnapshot) {
    if (questionarioSnapshot.exists) {
      questionario = Questionario.fromMap(questionarioSnapshot.data);
    } else
      print("bad");
  });

  List<Question> perguntas = [];
  for (var p in questionario.questions) {
    DocumentReference questionReference = p;
    Question pergunta;
    await questionReference.get().then((questionSnapshot) {
      if (questionSnapshot.exists) {
        pergunta = Question.fromMap(questionSnapshot.data);
      } else
        print("bad");
    });
    perguntas.add(pergunta);
  }
  perguntas.sort((a, b) => a.id.compareTo(b.id));

  return perguntas;
}

getPerguntasDoQuestionarioForAventura(List contents) async {
  List<Question> perguntas = [];
  contents.sort((a, b) => a.documentID.compareTo(b.documentID));
  
  for (var content in contents) {
    DocumentReference questionarioReference = content;

    Questionario questionario;

    await questionarioReference.get().then((questionarioSnapshot) {
      if (questionarioSnapshot.exists) {
        questionario = Questionario.fromMap(questionarioSnapshot.data);
      } else
        print("bad");
    });
    

    for (var p in questionario.questions) {
      
      DocumentReference questionReference = p;
      Question pergunta;
      await questionReference.get().then((questionSnapshot) {
        if (questionSnapshot.exists) {
          pergunta = Question.fromMap(questionSnapshot.data);
        } else
          print("bad");
      });
      perguntas.add(pergunta);
    }
  }
  

  return perguntas;
}

// RETORNA INSTANCIA DE UM ALUNO PELO ID

getAlunoById(alunoId) async {
  Aluno aluno;
  CollectionReference alunoRef = Firestore.instance.collection('aluno');

  DocumentReference documentRef = alunoRef.document(alunoId);
  await documentRef.get().then((alunoSnapchot) {
    if (alunoSnapchot.exists) {
      aluno = Aluno.fromMap(alunoSnapchot.data);
    } else {
      print("no data");
      aluno = null;
    }
  });

  return aluno;
}

// RETORNA UM MAPA, COM CAPITULOS E QUANTAS MISSOES UM CERTO ALUNOO JÁ FEZ NESSE CAPITULO

getDoneByCapitulo(alunoId, turmaId, escolaId) async {
  String historiaId;
  List<dynamic> capitulosId = [];
  List<dynamic> missoesDoc = [];
  List<int> capitulos_sorted = [];
  List<dynamic> finalList = [];
  String aventuraNome;

  Map<int, Map> mapa = {};
  List<dynamic> contents = [];
  double dones;
  int id = 0;
  List<dynamic> uploads = [];

  await Firestore.instance
      .collection('aventura')
      .where('escolas', arrayContains: escolaId)
      .getDocuments()
      .then((doc) {
    aventuraNome = doc.documents[0]['nome'];
    historiaId = doc.documents[0]['historia'];
  });

  await Firestore.instance
      .collection('historia')
      .where('id', isEqualTo: historiaId)
      .getDocuments()
      .then((doc) {
    capitulosId = doc.documents[0]['capitulos'];
  });

  for (var capituloId in capitulosId) {
    capitulos_sorted.add(int.parse(capituloId));
  }

  capitulos_sorted.sort();

  for (var capituloId in capitulos_sorted) {
    List<dynamic> allMissoes = [];
    dones = 0.0;
    List<dynamic> resultados = [];
    List<dynamic> allResultados = [];
    Map<String, double> totalAndDones = {};

    await Firestore.instance
        .collection('capitulo')
        .where('id', isEqualTo: capituloId.toString())
        .getDocuments()
        .then((doc) {
      missoesDoc = doc.documents[0]['missoes'];
    });
    for (var mission in missoesDoc) allMissoes.add(mission.documentID);

    for (var missionId in allMissoes) {
      await Firestore.instance
          .collection('mission')
          .where('id', isEqualTo: missionId)
          .getDocuments()
          .then((doc) {
        resultados = doc.documents[0]['resultados'];
        if (doc.documents[0]['type'] == 'Questionario')
          contents.add(doc.documents[0]['content']);
        if (doc.documents[0]['type'] == 'UploadImage' ||
            doc.documents[0]['type'] == 'UploadVideo') {
          for (var a in doc.documents[0]['resultados']) {
            if (a['aluno'] == alunoId) {
              if (a['linkUploaded'] != "") {
                uploads.add(a['linkUploaded']);
                break;
              }
            }
          }
        }
      });
      for (var result in resultados) {
        allResultados.add(result);
      }
    }

    for (var r in allResultados) {
      if (r['aluno'] == alunoId) if (r['done'] == true) dones++;
    }
    totalAndDones["total"] = allMissoes.length.toDouble();
    totalAndDones["dones"] = dones;

    mapa[id] = totalAndDones;
    id++;
  }

  finalList.add(mapa);
  finalList.add(contents);
  finalList.add(uploads);
  finalList.add(aventuraNome);

  return finalList;
}

getDoneByCapituloForEscola(escolaId) async {
  String historiaId;
  List<dynamic> capitulosId = [];
  List<dynamic> missoesDoc = [];
  List<int> capitulos_sorted = [];
  List<dynamic> finalList = [];
  List turmas = [];
  List alunos = [];
  String nome="";
  String nomeTurma="";
  Map<int, Map> mapa = {};
  List<dynamic> contents = [];
  double dones;
  int id = 0;
  List<dynamic> uploads = [];
  Map nomes={};

  await Firestore.instance
      .collection('escola')
      .where('id', isEqualTo: escolaId)
      .getDocuments()
      .then((doc) {
    turmas = doc.documents[0]['turmas'];
    nome= doc.documents[0]['nome'];
  });
  for (var turma in turmas) {
    await Firestore.instance
      .collection('turma')
      .where('id', isEqualTo: turma)
      .getDocuments()
      .then((doc) {
    nomeTurma = doc.documents[0]['nome'];
  });
  
    nomes[turma]=nomeTurma;
    getAlunosForTurma(turma)
        .then((value) => {for (var aluno in value) alunos.add(aluno)});
  }

  await Firestore.instance
      .collection('aventura')
      .where('escolas', arrayContains: escolaId)
      .getDocuments()
      .then((doc) {
    historiaId = doc.documents[0]['historia'];
  });

  await Firestore.instance
      .collection('historia')
      .where('id', isEqualTo: historiaId)
      .getDocuments()
      .then((doc) {
    capitulosId = doc.documents[0]['capitulos'];
  });

  for (var capituloId in capitulosId) {
    capitulos_sorted.add(int.parse(capituloId));
  }

  capitulos_sorted.sort();

  for (var capituloId in capitulos_sorted) {
    List<dynamic> allMissoes = [];
    dones = 0.0;
    List<dynamic> resultados = [];
    List<dynamic> allResultados = [];
    Map<String, double> totalAndDones = {};

    await Firestore.instance
        .collection('capitulo')
        .where('id', isEqualTo: capituloId.toString())
        .getDocuments()
        .then((doc) {
      missoesDoc = doc.documents[0]['missoes'];
    });
    for (var mission in missoesDoc) allMissoes.add(mission.documentID);

    for (var missionId in allMissoes) {
      await Firestore.instance
          .collection('mission')
          .where('id', isEqualTo: missionId)
          .getDocuments()
          .then((doc) {
        resultados = doc.documents[0]['resultados'];
        if (doc.documents[0]['type'] == 'Questionario')
          contents.add(doc.documents[0]['content']);
      });
      for (var result in resultados) {
        allResultados.add(result);
      }
    }

    for (var r in allResultados) {
      if (alunos.contains(r['aluno'])) if (r['done'] == true) dones++;
    }
    totalAndDones["total"] = allMissoes.length.toDouble() * alunos.length;
    totalAndDones["dones"] = dones;

    mapa[id] = totalAndDones;
    id++;
  }

  finalList.add(mapa);
  finalList.add(turmas);
  finalList.add(contents);
  finalList.add(nomes);
  finalList.add(nome);

  return finalList;
}

getDoneByCapituloForTurma(escolaId, turmas) async {
  String historiaId;
  List<dynamic> capitulosId = [];
  List<dynamic> missoesDoc = [];
  List<int> capitulos_sorted = [];
  List<dynamic> finalList = [];

  Map mapaTurma = {};

  Map mapaFinal = {};
String nomeTurma="";
  double dones;
  int id;

  await Firestore.instance
      .collection('aventura')
      .where('escolas', arrayContains: escolaId)
      .getDocuments()
      .then((doc) {
    historiaId = doc.documents[0]['historia'];
  });

  await Firestore.instance
      .collection('historia')
      .where('id', isEqualTo: historiaId)
      .getDocuments()
      .then((doc) {
    capitulosId = doc.documents[0]['capitulos'];
  });
  for (var capituloId in capitulosId) {
    capitulos_sorted.add(int.parse(capituloId));
  }

  capitulos_sorted.sort();

  for (var turma in turmas) {
   
    id = 0;
    List alunosDaTurma = [];
    alunosDaTurma = await getAlunosForTurma(turma);
  
    Map mapa = {};

    for (var capituloId in capitulos_sorted) {
      List<dynamic> allMissoes = [];
      dones = 0.0;
      List<dynamic> resultados = [];
      List<dynamic> allResultados = [];
      Map<String, double> totalAndDones = {};

      await Firestore.instance
          .collection('capitulo')
          .where('id', isEqualTo: capituloId.toString())
          .getDocuments()
          .then((doc) {
        missoesDoc = doc.documents[0]['missoes'];
      });
      for (var mission in missoesDoc) allMissoes.add(mission.documentID);

      for (var missionId in allMissoes) {
        await Firestore.instance
            .collection('mission')
            .where('id', isEqualTo: missionId)
            .getDocuments()
            .then((doc) {
          resultados = doc.documents[0]['resultados'];
        });
        for (var result in resultados) {
          allResultados.add(result);
        }
      }

      for (var r in allResultados) {
        
        if (alunosDaTurma.contains(r['aluno'])) {
         
        
        if (r['done'] == true) dones++;
        }
      }
      totalAndDones["total"] =
          allMissoes.length.toDouble() * alunosDaTurma.length;
      totalAndDones["dones"] = dones;
      
      mapa[id] = totalAndDones;
      id++;
    }
    
   
     await Firestore.instance
      .collection('turma')
      .where('id', isEqualTo: turma)
      .getDocuments()
      .then((doc) {
    nomeTurma = doc.documents[0]['nome'];
  
  });
    mapaTurma[nomeTurma] = mapa;
  }

  finalList.add(mapaTurma);

  return finalList;
 
}

getQuestionarioRespostasGeralDaAventura(List perguntas, List alunos) {
  Map perguntaRespostas = {};
  
 

  for (var pergunta in perguntas) {
        
  
    List respostas = [];
    for (var campo in pergunta.resultados) {
      if (alunos.contains(campo['aluno'])) if (campo['respostaNumerica'] !=
          null) respostas.add(campo['respostaNumerica']);
    }

    if (perguntaRespostas.containsKey(pergunta.question))
      perguntaRespostas[pergunta.question].add(respostas);
    else {
      perguntaRespostas[pergunta.question] = [];
      perguntaRespostas[pergunta.question].add(respostas);
    }
   
    
  }

  return perguntaRespostas;
}

// RETORNA DADOS PARA A VIZUALIZAÇÃO DA TABELA DO QUESTIONÁRIO DE UM ALUNO

getQuestionarioRespostas(perguntas, alunoId, perguntaRespostas) {
  List lista = [];
  Map<String, String> counterResposta = {};
  int i = 0;
  for (var pergunta in perguntas) {
    for (var campo in pergunta.resultados) {
      if (campo['aluno'] == alunoId) {
        counterResposta["resposta" + i.toString()] = campo['respostaEscolhida'];

        break;
      }
    }

    if (perguntaRespostas.containsKey(pergunta.question))
      perguntaRespostas[pergunta.question]
          .add(counterResposta["resposta" + i.toString()]);
    else {
      perguntaRespostas[pergunta.question] = [];
      perguntaRespostas[pergunta.question]
          .add(counterResposta["resposta" + i.toString()]);
    }
    i++;
  }

  return perguntaRespostas;
}

// RETORNA NOME DA ESCOLA PELO SEU ID

getEscolaNome(String escolaId) async {
  String nome;
  await Firestore.instance
      .collection('escola')
      .where('id', isEqualTo: escolaId)
      .getDocuments()
      .then((doc) {
    nome = doc.documents[0]['nome'];
  });

  return nome;
}



// DESBLOQUEIA O CAPITULO PARA UMA TURMA


desbloquearCapituloParaTurma(capitulo,turma) async {
  CollectionReference capituloRef = Firestore.instance.collection('capitulo');


  capitulo.disponibilidade.forEach((k,v) {
  
    if(k==turma) capitulo.disponibilidade[k]=true;
  });
  

  await capituloRef
      .document(capitulo.id)
      .updateData({'disponibilidade': capitulo.disponibilidade});
}


