class Question{
  String id;
  String question;
  String correctAnswer;
  List wrongAnswers;
  bool multipleChoice;
  List allAnswers = [];
  bool done;
  bool success;
  List answers = [];
  String respostaEscolhida = "";
  List resultados;

  Question();

  Question.fromMap(Map<String, dynamic> data){
    id = data['id'];
    question = data['question'];
    correctAnswer = data['correct_answer'];
    wrongAnswers = data['wrong_answers'];
    multipleChoice = data['multiple_choice'];
    done = data['done'];
    success = data['success'];
    answers = data['answers'];
    respostaEscolhida = data['respostaEscolhida'];
    resultados = data['resultados'];
  }

  List sortedListAnswers (){
    allAnswers = [];
    allAnswers.addAll(this.wrongAnswers);
    allAnswers.add(this.correctAnswer);
    return allAnswers;
  }

  Map<String, dynamic> toMap() {
    return {
    'id': id,
    'question' :question,
    'correct_answer' : correctAnswer,
    'wrong_answers' : wrongAnswers,
    'multiple_choice' : multipleChoice,
    'resultados': resultados,
    };
  }

}