import 'dart:io';
import 'package:app_criancas/models/questionario.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../models/question.dart';
import '../models/quiz.dart';
import '../notifier/missions_notifier.dart';
import '../models/mission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/activity.dart';

// API FIRESTORE AND STORAGE FUNCTIONS FOR MISSIONS PAGE

///////// BUSCAR TODAS AS MISSÕES NO FIRESTORE E CRIAR UMA LISTA COM INSTÂNCIAS DELAS
MissionsNotifier missionNotifier;
getMissions(
    MissionsNotifier missionsNotifier, List missions, String _userID) async {
  bool done;
  missionNotifier = missionsNotifier;
  List<Mission> _missionListFinal = [];
  List<Mission> _missionListNotDone = [];
  List<Mission> _missionListDone = [];

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
      }
      for (var a in mission.resultados) {
        if (a["aluno"] == _userID) {
          done = a["done"];
        }
      }

      if (done == false) {
        _missionListNotDone.add(mission);
      } else {
        _missionListDone.add(mission);
      }
      _missionListFinal = _missionListNotDone + _missionListDone;
      missionNotifier.missionsList = _missionListFinal;
    });
  });
}

//get das informações do user
getUserInfo(String email) async {
  print(email);
  DocumentReference user =
      Firestore.instance.collection('aluno').document(email);
  bool data = await user.get().then((value) {
    bool dataSaved;
    if (value['dataNascimentoAluno'] != null &&
        (value['generoAluno'] == 'Masculino' || value['generoAluno'] == 'Feminino')) {
      dataSaved = true;
    } else {
      dataSaved = false;
    }
    return dataSaved;
  });
  return data;
}

/////// UPLOAD DE UMA IMAGEM PARA O FIREBASE STORAGE
addUploadedImageToFirebaseStorage(File localFile, titulo) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/uploaded_images_children/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    return url;
  }
}

/////// UPLOAD DE UM VIDEO PARA O FIREBASE STORAGE
addUploadedVideoToFirebaseStorage(File localFile, String titulo) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/uploaded_videos_children/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    return url;
  }
}

/////// UPLOAD DE UM AUDIO PARA O FIREBASE STORAGE
addUploadedAudioToFirebaseStorage(File localFile, String titulo) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/uploaded_audios/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
  }
}

//////// ATUALIZAR A MISSÃO COM DONE ( FEITA )
updateMissionDoneInFirestore(Mission mission, String id) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["done"] = true;
    }
  });
  mission.reload = true;

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

// UPDATE DO DONE COM LINK DO FICHEIRO UPLOADED ( APENAS PARA MISSAO DE UPLOAD IMAGEM OU VIDEO )

updateMissionDoneWithLinkInFirestore(
    Mission mission, String id, String url) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["done"] = true;
      mapa["linkUploaded"] = url;
    }
  });
  mission.reload = true;

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

//para saber o número de tentativas

updateMissionCounterInFirestore(Mission mission, String id, int counter) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["counter"] = counter;
    }
  });

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

updateMissionQuizResultInFirestore(
    Mission mission, String id, int result) async {
  Map<String, dynamic> mapa;
  mission.content.resultados.forEach((element) {
    mapa = element;
    if (mapa["aluno"] == id) {
      mapa["result"] = result;
    }
  });

  await mission.content.id
      .updateData({'resultados': mission.content.resultados});
}

updateMissionQuizQuestionDone(Question question, String id) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  Map<String, dynamic> mapa;
  question.resultados.forEach((element) {
    mapa = element;
    if (mapa["aluno"] == id) {
      mapa["done"] = question.done;
    }
  });
  await questionRef
      .document(question.id)
      .updateData({'resultados': question.resultados});
}

updateMissionQuizQuestionSuccess(Question question, String id) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  Map<String, dynamic> mapa;
  question.resultados.forEach((element) {
    mapa = element;
    if (mapa["aluno"] == id) {
      mapa["success"] = question.success;
    }
  });
  await questionRef
      .document(question.id)
      .updateData({'resultados': question.resultados});
}

updateMissionQuizQuestionTDone(Question question) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  await questionRef.document(question.id).updateData({'done': question.done});
}

updateMissionQuizQuestionTSuccess(Question question) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  await questionRef
      .document(question.id)
      .updateData({'success': question.success});
}

updateMissionTimeAndCounterVisitedInFirestore(
    Mission mission, String id, int timeVisited, int counterVisited) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["counterVisited"] = counterVisited;

      mapa["timeVisited"] = timeVisited;
    }
  });

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

updateMissionTimeAndCounterVisitedInFirestoreVideo(Mission mission, String id,
    int timeVisited, int counterVisited, int counterPause) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["counterVisited"] = counterVisited;
      mapa["timeVisited"] = timeVisited;
      mapa["counterPause"] = counterPause;
    }
  });

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

saveMissionMovementAndLightDataInFirestore(
    Mission mission, String id, List movementData, List lightData) async {
  CollectionReference missionRef = Firestore.instance.collection('mission');

  Map<String, dynamic> mapa;

  mission.resultados.forEach((element) {
    mapa = element;

    if (mapa["aluno"] == id) {
      mapa["movementData"] = movementData;
      mapa["lightData"] = lightData;
    }
  });

  await missionRef
      .document(mission.id)
      .updateData({'resultados': mission.resultados});
}

updateAnswerQuestion(Question question, String id) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  Map<String, dynamic> mapa;
  question.resultados.forEach((element) {
    mapa = element;
    if (mapa["aluno"] == id) {
      mapa["respostaEscolhida"] = question.respostaEscolhida;
      mapa["respostaNumerica"] = question.respostaNumerica;
    }
  });
  await questionRef
      .document(question.id)
      .updateData({'resultados': question.resultados});
}
