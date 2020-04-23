import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../notifier/missions_notifier.dart';
import '../models/mission.dart';
import '../models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';



// API FIRESTORE AND STORAGE FUNCTIONS FOR MISSIONS PAGE


///////// BUSCAR TODAS AS MISSÕES NO FIRESTORE E CRIAR UMA LISTA COM INSTÂNCIAS DELAS



MissionsNotifier missionNotifier;

getMissions(MissionsNotifier missionsNotifier) async {

  missionNotifier=missionsNotifier;

  List<Mission> _missionListFinal = [];
  

  QuerySnapshot snapshot =
      await Firestore.instance.collection("mission").getDocuments();


  snapshot.documents.forEach((document) { 
    
    Mission mission = Mission.fromMap(document.data);

    if(mission.type == "Activity"){

      List<Activity> activities = [];

      DocumentReference activityReference;

      for (activityReference in mission.content){
        activityReference.get().then( (activitySnapshot){
              if(activitySnapshot.exists){
                Activity activity = Activity.fromMap(activitySnapshot.data);
                activities.add(activity);
              }
            });
      mission.content=activities;
      }

     
      

      

    }

     _missionListFinal.add(mission);
  });



  missionsNotifier.missionsList = _missionListFinal;
  

}

getMissionsLargerId() {

  List<Mission> _missionList=missionNotifier.missionsList;

  int _largerId=0;

  for(Mission m in _missionList) {
    int _idNumber=int.parse(m.id);
    if(_idNumber>_largerId){
      _largerId=_idNumber;

    }
  }

  return _largerId;


}


getActivitiesLargerId() {

  int _largerId=0;

  List<Mission> _missionList=missionNotifier.missionsList;


  for(Mission m in _missionList) {
    if(m.type=="Activity"){
      for(Activity a in m.content){
        int _idNumber=int.parse(a.id);
        if(_idNumber>_largerId){
          _largerId=_idNumber;
        }
    }
  }
  }

  return _largerId;

}






//////// CRIAR UMA NOVA MISSAO DO TIPO IMAGEM COM A IMAGEM QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER;
/// SE OS UPLOADS FUNCIONAM, ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")




createMissionImageInFirestore(String imageUrl,String titulo,String descricao) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');
  
  
  if (imageUrl != null) {
    mission.linkImage = imageUrl;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.reload=false;
    mission.type = 'Image';
    mission.content=descricao;
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}


/////// UPLOAD DE UMA IMAGEM PARA O FIREBASE STORAGE


addUploadedImageToFirebaseStorage(String titulo, String descricao,File localFile) async {

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

    createMissionImageInFirestore(imageUrl, titulo, descricao);
   
  }


}


  uploadImageToFirebaseStorage(File localFile) async {

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

    return imageUrl;

  }

// PRIMEIRO CRIA SE OS DOCUMENTOS PARA CADA ATIVIDADE
// DEPOIS CRIA-SE A MISSÃO COM A LISTA DOS DOCUMENTOS DE ATIVIDADE


  createMissionActivityInFirestore(String titulo, List<Activity> activities) async{

    CollectionReference activityRef = Firestore.instance.collection('activity');

    List<dynamic> documentos = new List<dynamic>();

    var rng = new Random();

    for(Activity activity in activities) {

      int index=(activities.indexOf(activity))+1;

      activity.id=(rng.nextInt(1000)+rng.nextInt(1000)+index).toString();
      
      DocumentReference documentRef = activityRef.document(activity.id);

      await documentRef.setData(activity.toMap());

      documentos.add(documentRef);

     

      



    }

    

    

    Mission mission = new Mission();

    CollectionReference missionRef = Firestore.instance.collection('mission');
  
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.reload = false;
    mission.type = 'Activity';
    mission.content=documentos;
  

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());


  }








//////// CRIAR UMA NOVA MISSAO DO TIPO VIDEO COM O VIDEO QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER 
/// SE OS UPLOADS FUNCIONAM; ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")


createMissionVideoInFirestore(String videoUrl, String titulo, String descricao) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (videoUrl != null) {
    mission.linkVideo = videoUrl;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Video';
    mission.reload=false;
    mission.content=descricao;
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}


/////// UPLOAD DE UM VIDEO PARA O FIREBASE STORAGE


addUploadedVideoToFirebaseStorage(String titulo, String descricao, File localFile) async {

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

    createMissionVideoInFirestore(url,titulo,descricao);
  }

}






//////// CRIAR UMA NOVA MISSAO DO TIPO AUDIO COM O AUDIO QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER 
/// SE OS UPLOADS FUNCIONAM; ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")


createMissionAudioInFirestore(String audioUrl,String titulo,String descricao) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (audioUrl != null) {
    mission.linkAudio = audioUrl;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Audio';
    mission.reload = false;
    mission.content=descricao;
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}


/////// UPLOAD DE UM AUDIO PARA O FIREBASE STORAGE


addUploadedAudioToFirebaseStorage(String titulo, String descricao,File localFile) async {

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

    createMissionAudioInFirestore(url,titulo,descricao);

  }

}





//////// ATUALIZAR UMA DADA MISSÃO COM UM DADO CAMPO
//// NO CASO DAS CRIANÇAS, SERIA NECESSÁRIO ATUALIZAR OS CAMPOS DE :
/// - DONE (SE A MISSÃO FOI FEITA OU NÃO)
/// - RESULTADOS : ?  ( TO DO )




updateMissionDoneInFirestore(Mission mission) async {

  CollectionReference missionRef = Firestore.instance.collection('mission');

  mission.done = true;
  mission.reload = true;

  

  await missionRef.document(mission.id).updateData({'done':mission.done,'reload':mission.reload});


}


createMissionTextInFirestore(String titulo,String conteudo) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (titulo != null && conteudo!=null) {
    mission.title=titulo;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.counter = 0;
    mission.done = false;
    mission.reload=false;
    mission.content=conteudo;
    mission.type = 'Text';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}



createMissionUploadImageInFirestore(String titulo,String descricao) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (titulo != null && descricao!=null) {
    mission.title=titulo;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.counter = 0;
    mission.done = false;
    mission.reload=false;
    mission.content=descricao;
    mission.type = 'UploadImage';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}




createMissionUploadVideoInFirestore(String titulo,String descricao) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (titulo != null && descricao!=null) {
    mission.title=titulo;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.counter = 0;
    mission.done = false;
    mission.reload=false;
    mission.content=descricao;
    mission.type = 'UploadVideo';
  }

  DocumentReference documentRef = missionRef.document(mission.id);

  await documentRef.setData(mission.toMap());

}


deleteMissionInFirestore(Mission mission) async {

  if(mission.type=="Activity"){
    for(Activity a in mission.content){
      
      CollectionReference activityRef = Firestore.instance.collection('activity');

      await activityRef.document(a.id).delete();
    }
  }

  CollectionReference missionRef = Firestore.instance.collection('mission');

  await missionRef.document(mission.id).delete();

}



