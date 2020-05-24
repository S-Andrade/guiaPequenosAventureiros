import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  Timestamp dataNascimentoAluno;
  String generoAluno;
  String habilitacoesMae;
  String habilitacoesPai;
  String id;
  String grauParentescoEE;
  String idadeAluno;
  String idadeMae;
  String idadePai;
  String idadeEE;
  String maisInfo;
  String nacionalidadeAluno;
  String nacionalidadeMae;
  String nacionalidadePai;
  String profissaoMae;
  String profissaoPai;
  String idadeIngresso;
  bool frequentouPre;
  String turma;
  String escola;
  List cromos;
  int pontuacao;

  Aluno();

  Aluno.fromMap(Map<String, dynamic> data) {
    dataNascimentoAluno = data['dataNascimentoAluno'];
    generoAluno = data['generoAluno'];
    habilitacoesMae = data['habilitacoesMae'];
    habilitacoesPai = data['habilitacoesPai'];
    id = data['id'];
    grauParentescoEE = data['grauParentescoEE'];
    idadeAluno = data['idadeAluno'];
    idadeMae = data['idadeMae'];
    idadePai = data['idadePai'];
    maisInfo = data['maisInfo'];
    nacionalidadeAluno = data['nacionalidadeAluno'];
    nacionalidadeMae = data['nacionalidadeMae'];
    nacionalidadePai = data['nacionalidadePai'];
    profissaoMae = data['profissaoMae'];
    profissaoPai = data['profissaoPai'];
    idadeIngresso = data['idadeIngresso'];
    turma = data['turma'];
    escola = data['escola'];
    frequentouPre = data['frequentouPre'];
    idadeEE=data['idadeEE'];
    cromos = data['cromos'];
    pontuacao = data['pontuacao'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dataNascimentoAluno': dataNascimentoAluno,
      'generoAluno': generoAluno,
      'habilitacoesMae': habilitacoesMae,
      'habilitacoesPai': habilitacoesPai,
      'id': id,
      'grauParentescoEE': grauParentescoEE,
      'idadeAluno': idadeAluno,
      'idadeMae': idadeMae,
      'idadePai': idadePai,
      'maisInfo': maisInfo,
      'nacionalidadeAluno': nacionalidadeAluno,
      'nacionalidadeMae': nacionalidadeMae,
      'nacionalidadePai': nacionalidadePai,
      'profissaoMae': profissaoMae,
      'profissaoPai': profissaoPai,
      'idadeIngresso': idadeIngresso,
      'cromos': cromos,
      'pontuacao': pontuacao
    };
  }
}
