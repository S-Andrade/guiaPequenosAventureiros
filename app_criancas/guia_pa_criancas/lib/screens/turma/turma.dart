
import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {

  final String id;
  final String professor;
  final int nAlunos;
  final List alunos;

  Turma( {this.id, this.professor, this.nAlunos, this.alunos});
}