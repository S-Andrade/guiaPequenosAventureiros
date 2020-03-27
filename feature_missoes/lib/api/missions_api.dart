import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../notifiers/missions_notifier.dart';
import '../models/mission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// API FIRESTORE AND STORAGE FUNCTIONS FOR MISSIONS PAGE


///////// BUSCAR TODAS AS MISSÕES NO FIRESTORE E CRIAR UMA LISTA COM INSTÂNCIAS DELAS

List<Mission> _missionList = [];

getMissions(MissionsNotifier missionNotifier) async {

  QuerySnapshot snapshot =
      await Firestore.instance.collection("mission").getDocuments();


  snapshot.documents.forEach((document) {
    Mission mission = Mission.fromMap(document.data);
    _missionList.add(mission);
  });

  missionNotifier.missionsList = _missionList;
  

}

getMissionsLargerId() {

  int _largerId=0;

  for(Mission m in _missionList) {
    int _idNumber=int.parse(m.id);
    if(_idNumber>_largerId){
      _largerId=_idNumber;

    }
  }

  return _largerId;


}



//////// CRIAR UMA NOVA MISSAO DO TIPO IMAGEM COM A IMAGEM QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER;
/// SE OS UPLOADS FUNCIONAM, ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")


createMissionImageInFirestore(String imageUrl,String titulo) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');
  
  
  if (imageUrl != null) {
    mission.linkImage = imageUrl;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Image';
  }

  DocumentReference documentRef = await missionRef.add(mission.toMap());

  await documentRef.setData(mission.toMap());

}


/////// UPLOAD DE UMA IMAGEM PARA O FIREBASE STORAGE


addUploadedImageToFirebaseStorage(File localFile,titulo) async {

  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('mission/uploaded_images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    createMissionImageInFirestore(url,titulo);
  }

}



//////// CRIAR UMA NOVA MISSAO DO TIPO VIDEO COM O VIDEO QUE SE FEZ UPLOAD PARA
/// O FIREBASE STORAGE ( SERVE APENAS DE EXEMPLO PARA VER 
/// SE OS UPLOADS FUNCIONAM; ESTA FUNÇÃO SERÁ APENAS NECESSÁRIA NA PARTE DOS MODERADORES,
/// POIS AS CRIANÇAS NÃO CRIAM MISSÕES, APENAS AS VIZUALIZAM E "RESOLVEM")


createMissionVideoInFirestore(String videoUrl,String titulo) async {

  Mission mission = new Mission();

  CollectionReference missionRef = Firestore.instance.collection('mission');

  if (videoUrl != null) {
    mission.linkVideo = videoUrl;
    mission.id = (getMissionsLargerId()+1).toString();
    mission.title = titulo;
    mission.counter = 0;
    mission.done = false;
    mission.type = 'Video';
  }

  DocumentReference documentRef = await missionRef.add(mission.toMap());

  await documentRef.setData(mission.toMap());

}


/////// UPLOAD DE UM VIDEO PARA O FIREBASE STORAGE


addUploadedVideoToFirebaseStorage(File localFile,String titulo) async {

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

    createMissionVideoInFirestore(url,titulo);
  }

}
