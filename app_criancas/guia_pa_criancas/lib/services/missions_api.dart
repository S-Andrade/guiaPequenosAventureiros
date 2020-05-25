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
getMissions(MissionsNotifier missionsNotifier, List missions, String _userID) async {

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

      } 
      
      else if (mission.type == "Activity") {
        
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

      }
      else if(mission.type=='Questionario'){
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
          questionario.questions =  questions;
          mission.content = questionario;
          missionsNotifier.missionContent = questionario;
          }
        });
    }
      for(var a in mission.resultados){
        if(a["aluno"]==_userID){
          done=a["done"];
        }
      }
      
      if (done == false){
        _missionListNotDone.add(mission);
      }
      else{
        print('feito');
        _missionListDone.add(mission);
      }
      _missionListFinal = _missionListNotDone + _missionListDone;
      missionNotifier.missionsList = _missionListFinal;
    });
  });
}


/*
getMissionsLargerId() {
  List<Mission> _missionList = missionNotifier.missionsList;

  int _largerId = 0;

  for (Mission m in _missionList) {
    int _idNumber = int.parse(m.id);
    if (_idNumber > _largerId) {
      _largerId = _idNumber;
    }
  }

  return _largerId;
}

*/

//////// CRIAR UMA NOVA MISSAO DO TIPO IMAGEM COM A IMAGEM QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER;
/// SE OS UPLOADS FUNCIONAM, ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")

/*
createMissionImageInFirestore(String imageUrl, String titulo) async {

  // TO BE CHANGED; HOW TO STORE AND PRESENT THE IMAGE UPLOADED BY CHILDREN?

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (imageUrl != null) {
    mission.linkImage = imageUrl;
    mission.id = (getMissionsLargerId() + 1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Image';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());
}

*/

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

    
  }
}

//////// CRIAR UMA NOVA MISSAO DO TIPO VIDEO COM O VIDEO QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER
/// SE OS UPLOADS FUNCIONAM; ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")

/*
createMissionVideoInFirestore(String videoUrl, String titulo) async {
  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (videoUrl != null) {
    mission.linkVideo = videoUrl;
    mission.id = (getMissionsLargerId() + 1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Video';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());
}
*/
/////// UPLOAD DE UM VIDEO PARA O FIREBASE STORAGE

addUploadedVideoToFirebaseStorage(File localFile, String titulo) async {
  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/uploaded_videos/$uuid$fileExtension');

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

//////// CRIAR UMA NOVA MISSAO DO TIPO AUDIO COM O AUDIO QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER
/// SE OS UPLOADS FUNCIONAM; ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")

/*
createMissionAudioInFirestore(String audioUrl, String titulo) async {
  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (audioUrl != null) {
    mission.linkAudio = audioUrl;
    mission.id = (getMissionsLargerId() + 1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Audio';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());
}
*/

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

//////// ATUALIZAR UMA DADA MISSÃO COM UM DADO CAMPO
//// NO CASO DAS CRIANÇAS, SERIA NECESSÁRIO ATUALIZAR OS CAMPOS DE :
/// - DONE (SE A MISSÃO FOI FEITA OU NÃO)
/// - RESULTADOS : ?  ( TO DO )

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

updateMissionQuizResultInFirestore(Mission mission) async {
  DocumentReference missionRef = mission.content.id;
  await missionRef.updateData({'result': mission.content.result});
}

updateMissionQuizQuestionDone(Question question) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  await questionRef.document(question.id).updateData({'done': question.done});
}

updateMissionQuizQuestionSuccess(Question question) async {
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

updateAnswerQuestion(Question question) async {
  CollectionReference questionRef = Firestore.instance.collection('question');
  await questionRef
      .document(question.id)
      .updateData({'respostaEscolhida': question.respostaEscolhida});
}
