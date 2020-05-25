import 'package:cloud_firestore/cloud_firestore.dart';

class Questionario{
  List questions;
  DocumentReference id;

  Questionario();

  Questionario.fromMap(Map<String, dynamic> data){
    questions = data['questions'];
  }

   Map<String, dynamic> toMap() {
    return {
      'questions':questions,
    };
  }

  set idSetter(DocumentReference id){
    this.id = id;
  }
}