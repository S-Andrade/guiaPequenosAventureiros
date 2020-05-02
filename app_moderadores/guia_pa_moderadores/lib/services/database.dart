import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/moderador/moderador.dart';
import '../screens/aventura/aventura.dart';
import '../screens/capitulo/capitulo.dart';
import '../screens/turma/turma.dart';
import '../screens/escola/escola.dart';
import '../screens/historia/historia.dart';

class DatabaseService {

  //----------------------------------------------------------------------------------------------------------------------------------------------------------
  //Aventura

  final CollectionReference aventuraCollection = Firestore.instance.collection('aventura');

  Future<void> updateAventuraData(String id , String historia, Timestamp data, String local ,List escolas, String moderador, String nome) async {
    return await aventuraCollection.document(id).setData({
      'id' : id,
      'historia' : historia,
      'data' : data,
      'local': local,
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

  List<Historia> _historiaListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Historia(
        id: doc.data['id'] ?? '',
        titulo: doc.data['titulo'] ?? '',
        capitulos: doc.data['capitulos'] ?? '',
        capa: doc.data['capa'] ?? ''
      );
    }).toList();
  }

  Stream<List<Historia>> get historia {
    return historiaCollection.snapshots().map(_historiaListFRomSnapshot);
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
//Escola

  final CollectionReference escolaCollection = Firestore.instance.collection('escola');

  Future<void> updateEscolaData(String id , String nome, List turmas) async {
    return await escolaCollection.document(id).setData({
      'id': id,
      'nome' : nome,
      'turmas' : turmas,
    });
  }

  List<Escola> _escolaListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Escola(
        id: doc.data['id'] ?? '',
        nome: doc.data['nome'] ?? '',
        turmas: doc.data['turmas'] ?? []
      );
    }).toList();
  }

  Stream<List<Escola>> get escola {
    return escolaCollection.snapshots().map(_escolaListFRomSnapshot);
  }

//-------------------------------------------------------------------------------------------------------------------------
//Turma

  final CollectionReference turmaCollection = Firestore.instance.collection('turma');

  Future<void> updateTurmaData(String id , String nome,String professor, int nAlunos, List alunos, String file) async {
    return await turmaCollection.document(id).setData({
      'id': id,
      'nome': nome,
      'professor' : professor,
      'nAlunos' : nAlunos,
      'alunos' : alunos,
      'file' : file,
    });
  }

  List<Turma> _turmaListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Turma(
        id: doc.data['id'] ?? '',
        nome: doc.data['nome'] ?? '',
        professor: doc.data['professor'] ?? '',
        nAlunos: doc.data['nAlunos'] ?? 0,
        alunos: doc.data['alunos'] ?? [],
        file: doc.data['file'] ?? '',
      );
    }).toList();
  }

  Stream<List<Turma>> get turma {
    return turmaCollection.snapshots().map(_turmaListFRomSnapshot);
  }

//-------------------------------------------------------------------------------------------------------------------------
//Aluno

  /*final CollectionReference alunoCollection = Firestore.instance.collection('aluno');

  Future<void> updateAlunoData(String id , String password, String nome) async {
    return await alunoCollection.document(id).setData({
      'id':id,
      'password' : password,
      'nome' : nome,
    });
  }*/

  void updateUserData(String id, String idade, String genero, DateTime dateTime, bool frequentouPre, String idadeIngresso, String maisInfo, String nacionalidade, String nacionalidadeEE, String grauParentesco, String habilitacoesEE, String idadeEE, String profissaoEE, String profissaoMae, String idadeMae, String nacionalidadeMae, String habilitacoesMae, String idadePai, String nacionalidadePai, String profissaoPai, String habilitacoesPai, String turma, String escola) {
  CollectionReference alunoCollection = Firestore.instance.collection('aluno');
  alunoCollection.document(id).setData({
    'idadeAluno': idade,
    'generoAluno': genero,
    'dataNascimentoAluno': dateTime,
    'frequentouPre': frequentouPre,
    'idadeIngresso': idadeIngresso,
    'maisInfo': maisInfo,
    'nacionalidadeAluno': nacionalidade,
    'grauParentescoEE': grauParentesco,
    'idadeEE': idadeEE,
    'profissaoEE':profissaoEE,
    'nacionalidadeEE': nacionalidadeEE,
    'habilitacoesEE': habilitacoesEE,
    'idadeMae': idadeMae,
    'idadePai': idadePai,
    'profissaoMae': profissaoMae,
    'profissaoPai': profissaoPai,
    'nacionalidadeMae': nacionalidadeMae,
    'nacionalidadePai': nacionalidadePai,
    'habilitacoesMae': habilitacoesMae,
    'habilitacoesPai': habilitacoesPai,
    'turma': turma,
    'escola': escola
  });

}

//-------------------------------------------------------------------------------------------------------------------------
//Moderador

  final CollectionReference moderadorCollection = Firestore.instance.collection('moderador');

  Future<void> updateModeradorData(String id) async {
    return await turmaCollection.document(id).setData({
      'id': id,
    });
  }

  List<Moderador> _moderadorListFRomSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Moderador(
        id: doc.data['id'] ?? '',
      );
    }).toList();
  }

  Stream<List<Moderador>> get moderador {
    return moderadorCollection.snapshots().map(_moderadorListFRomSnapshot);
  }

}
