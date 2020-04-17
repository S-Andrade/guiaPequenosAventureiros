import 'package:cloud_firestore/cloud_firestore.dart';

class Questionario{
  String respostaEscolhida;
  List questions;
  DocumentReference id;

  Questionario();

  Questionario.fromMap(Map<String, dynamic> data){
    respostaEscolhida = data['respostaEscolhida'];
    questions = data['questions'];
  }

   Map<String, dynamic> toMap() {
    return {
      'respostaEscolhida':respostaEscolhida,
      'questions':questions,
    };
  }

  set idSetter(DocumentReference id){
    this.id = id;
  }
}