import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz{
  int result;
  List questions;
  DocumentReference id;
  List resultados;
  

  Quiz();

  Quiz.fromMap(Map<String, dynamic> data){
    result = data['result'];
    questions = data['questions'];
    resultados=data['resultados'];
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