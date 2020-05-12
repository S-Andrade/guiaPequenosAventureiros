import 'package:cloud_firestore/cloud_firestore.dart';

class Companheiro{
  String bodyPart;
  String color;
  String eyes;
  String headTop;
  String id;
  String shape;
  DocumentReference owner;

  Companheiro();

  Companheiro.fromMap(Map<String, dynamic> data){
    bodyPart = data['body_part'];
    color = data['color'];
    eyes = data['eyes'];
    headTop = data['head_top'];
    id = data['id'];
    shape = data['shape'];
    owner = data['owner'];
  }

  Map<String, dynamic> toMap() {
    return {
      'body_part' : bodyPart,
      'color': color,
      'eyes' : eyes,
      'head_top' : headTop,
      'id' : id,
      'shape': shape,
      'owner' : owner,
    };
  }
}
