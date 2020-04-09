
import 'package:cloud_firestore/cloud_firestore.dart';

class Escola {

  final String id;
  final String nome;
  final List turmas; 

  Escola( {this.id, this.nome, this.turmas});
}