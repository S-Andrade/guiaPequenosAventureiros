

class Question{
  String id;
  String question;
  String correctAnswer;
  List wrongAnswers;
  bool multipleChoice;
  List allAnswers = [];
  bool done;
  bool success;
<<<<<<< HEAD
=======
  List answers = [];
  String respostaEscolhida = "";
>>>>>>> 58e5b144ed900107127f38daaf802d1e7be37994

  Question();

  Question.fromMap(Map<String, dynamic> data){
    id = data['id'];
    question = data['question'];
    correctAnswer = data['correct_answer'];
    wrongAnswers = data['wrong_answers'];
    multipleChoice = data['multiple_choice'];
    done = data['done'];
    success = data['success'];
<<<<<<< HEAD
=======
    answers = data['answers'];
    respostaEscolhida = data['respostaEscolhida'];
>>>>>>> 58e5b144ed900107127f38daaf802d1e7be37994
  }

  List sortedListAnswers (){
    allAnswers = [];
    allAnswers.addAll(this.wrongAnswers);
    allAnswers.add(this.correctAnswer);
    return allAnswers;
  }

}