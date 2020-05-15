import 'package:app_criancas/models/companheiro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//GET COMPANHEIRO
getCompanheiro(String userEmail) async {
  CollectionReference companheiroRef =
      Firestore.instance.collection('companheiro');
  DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
  Companheiro comp = await companheiroDocRef.get().then((snapshot) {
    Companheiro c = Companheiro.fromMap(snapshot.data);
    print('temp=');
    print(c);
    return c;
  });
  print('temp2=');
  print(comp.shape);
  print(comp.runtimeType);
  return comp;
}

////CRIAR COMPANHEIRO
//  createCompanheiro(String bodyPart, String color, String eyes, String headTop,
//      String userEmail, String shape) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    CollectionReference alunoRef = Firestore.instance.collection('aluno');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    DocumentReference owner = alunoRef.document(userEmail);
//    Companheiro companheiro = new Companheiro();
//    companheiro.bodyPart = bodyPart;
//    companheiro.color = color;
//    companheiro.eyes = eyes;
//    companheiro.headTop = headTop;
//    companheiro.id = userEmail;
//    companheiro.shape = shape;
//    companheiro.owner = owner;
//    await companheiroDocRef.setData(companheiro.toMap());
//  }
//
////UPDATE COMPANHEIRO
//  updateCompanheiroBody(String userEmail, String bodyPart) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    await companheiroDocRef.updateData({'body_part': bodyPart});
//  }
//
////UPDATE COLOR
//  updateCompanheiroColor(String userEmail, String color) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    await companheiroDocRef.updateData({'color': color});
//  }
//
////UPDATE EYES
//  updateCompanheiroEyes(String userEmail, String eyes) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    await companheiroDocRef.updateData({'eyes': eyes});
//  }
//
////UPDATE HEAD TOP
//  updateCompanheiroHead(String userEmail, String headTop) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    await companheiroDocRef.updateData({'head_top': headTop});
//  }
//
////UPDATE SHAPE
//  updateCompanheiroShape(String userEmail, String shape) async {
//    CollectionReference companheiroRef =
//        Firestore.instance.collection('companheiro');
//    DocumentReference companheiroDocRef = companheiroRef.document(userEmail);
//    await companheiroDocRef.updateData({'shape': shape});
//  }
//
