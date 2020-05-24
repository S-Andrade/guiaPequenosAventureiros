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

  Aluno({
    this.dataNascimentoAluno,
    this.generoAluno,
    this.habilitacoesMae,
    this.habilitacoesPai,
    this.id,
    this.grauParentescoEE,
    this.idadeAluno,
    this.idadeMae,
    this.idadePai,
    this.idadeEE,
    this.maisInfo,
    this.nacionalidadeAluno,
    this.nacionalidadeMae,
    this.nacionalidadePai,
    this.profissaoMae,
    this.profissaoPai,
    this.idadeIngresso,
    this.frequentouPre,
    this.turma,
    this.escola,
    this.cromos,
    this.pontuacao,
  });
}