import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz{
  int result;
  List questions;
  DocumentReference id;

  Quiz();

  Quiz.fromMap(Map<String, dynamic> data){
    result = data['result'];
    questions = data['questions'];
  }

   Map<String, dynamic> toMap() {
    return {
      'result':result,
      'questions':questions,
    };
  }

  set idSetter(DocumentReference id){
    this.id = id;
  }
}