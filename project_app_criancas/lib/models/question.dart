

class Question{
  String id;
  String question;
  String correctAnswer;
  List wrongAnswers;
  bool multipleChoice;
  List allAnswers = [];

  Question();

  Question.fromMap(Map<String, dynamic> data){
    id = data['id'];
    question = data['question'];
    correctAnswer = data['correct_answer'];
    wrongAnswers = data['wrong_answers'];
    multipleChoice = data['multiple_choice'];
  }

  List sortedListAnswers (){
    allAnswers = [];
    allAnswers.addAll(this.wrongAnswers);
    allAnswers.add(this.correctAnswer);
    return allAnswers;
  }

}