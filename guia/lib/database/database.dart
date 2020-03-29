
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guia/aventura/aventura.dart';
import 'package:guia/capitulo/capitulo.dart';

class DatabaseService {

  //----------------------------------------------------------------------------------------------------------------------------------------------------------
  //Aventura

  final CollectionReference aventuraCollection = Firestore.instance.collection('aventura');

  Future<void> updateAventuraData(String id , String historia, Timestamp data, String local, List escolas, String moderador, String nome) async {
    return await aventuraCollection.document(id).setData({
      'id' : id,
      'historia' : historia,
      'data' : data,
      'local' : local,
      'escolas' : escolas,
      'moderador' : moderador,
      'nome' : nome,
    });
  }

  List<Aventura> _aventuraListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Aventura(
        id: doc.data['id'] ?? '',
        historia: doc.data['historia'] ?? '',
        data: doc.data['data'] ?? Timestamp.now(),
        local: doc.data['local'] ?? '',
        escolas: doc.data['escolas'] ?? [],
        moderador: doc.data['moderador'] ?? '',
        nome: doc.data['nome'] ?? ''
      );
    }).toList();
  }

  Stream<List<Aventura>> get aventura {
    return aventuraCollection.snapshots().map(_aventuraListFRomSnapshot);
  }

//------------------------------------------------------------------------------------------
//Historia

  final CollectionReference historiaCollection = Firestore.instance.collection('historia');

  Future<void> updateHistoriaData(String id , String titulo, List capitulos, String capa) async {
    return await historiaCollection.document(id).setData({
      'id': id,
      'titulo' : titulo,
      'capitulos' : capitulos,
      'capa' : capa,
    });
  }


//---------------------------------------------------------------------------------------------------------------------------------
//capitulo 
  final CollectionReference capituloCollection = Firestore.instance.collection('capitulo');

  Future<void> updateCapituloData(String id , bool bloquado, List missoes) async {
    return await capituloCollection.document(id).setData({
      'id': id,
      'bloqueado' : bloquado,
      'missoes' : missoes,
    });
  }
   List<Capitulo> _capituloListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Capitulo(
        id: doc.data['id'] ?? '',
        bloqueado: doc.data['bloqueado'] ?? null,
        missoes: doc.data['missoes'] ?? []
      );
    }).toList();
  }

  Stream<List<Capitulo>> get capitulo {
    return capituloCollection.snapshots().map(_capituloListFRomSnapshot);
  }

//-------------------------------------------------------------------------------------------------------------------------

  final CollectionReference escolaCollection = Firestore.instance.collection('escola');

  Future<void> updateEscolaData(String id , String nome, List turmas) async {
    return await escolaCollection.document(id).setData({
      'id': id,
      'nome' : nome,
      'turmas' : turmas,
    });
  }

  final CollectionReference turmaCollection = Firestore.instance.collection('turma');

  Future<void> updateTurmaData(String id , String professor, int nAlunos, List alunos) async {
    return await turmaCollection.document(id).setData({
      'id': id,
      'professor' : professor,
      'nAlunos' : nAlunos,
      'alunos' : alunos,
    });
  }

  final CollectionReference alunoCollection = Firestore.instance.collection('aluno');

  Future<void> updateAlunoData(String id , String password, String nome) async {
    return await alunoCollection.document(id).setData({
      'id':id,
      'password' : password,
      'nome' : nome,
    });
  }

}