class Turma {

   String id;
   String nome;
   String professor;
   int nAlunos;
   List alunos;
  String file;

  Turma( {this.id, this.nome ,this.professor, this.nAlunos, this.alunos, this.file});

 Turma.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    alunos=data['alunos'];
    file=data['file'];
    nAlunos=data['nAlunos'];
    nome=data['nome'];
    professor=data['professor'];
  }

}