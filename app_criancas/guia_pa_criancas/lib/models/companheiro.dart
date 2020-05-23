import 'package:cloud_firestore/cloud_firestore.dart';

class Companheiro {
  String shape;
  String bodyPart;
  int color;
  String eyes;
  String headTop;
  String id;
  DocumentReference owner;

  Companheiro();

  Companheiro.fromMap(Map<String, dynamic> data) {
    shape = data['shape'] ?? '';
    bodyPart = data['body_part'] ?? '';
    color = data['color'] ?? 1;
    eyes = data['eyes'] ?? '';
    headTop = data['head_top'] ?? '';
    id = data['id'] ?? '';
    owner = data['owner'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'shape': shape,
      'body_part': bodyPart,
      'color': color,
      'eyes': eyes,
      'head_top': headTop,
      'id': id,
      'owner': owner,
    };
  }
}
