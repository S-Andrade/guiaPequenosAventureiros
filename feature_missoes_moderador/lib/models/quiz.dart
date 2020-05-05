import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz{
  List resultados;
  List questions;
  DocumentReference id;

  Quiz();

  Quiz.fromMap(Map<String, dynamic> data){
    resultados = data['resultados'];
    questions = data['questions'];
  }

   Map<String, dynamic> toMap() {
    return {
      'resultados':resultados,
      'questions':questions,
    };
  }

  set idSetter(DocumentReference id){
    this.id = id;
  }
}