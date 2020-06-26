import 'package:cloud_firestore/cloud_firestore.dart';

class Aventura {
  final String id;
  final String historia;
  final Timestamp data;
  final String local;
  final List escolas;
  final String moderador;
  final String nome;
  final String capa;

  Aventura(
      {this.id,
      this.historia,
      this.data,
      this.local,
      this.escolas,
      this.moderador,
      this.nome,
      this.capa});
}
