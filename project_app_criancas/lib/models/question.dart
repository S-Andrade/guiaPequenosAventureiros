class Question{
  String id;
  String question;
  String corretAnswer;
  List wrongAnswers;
  bool multipleChoice;

  Question();

  Question.fromMap(Map<String, dynamic> data){
    id = data['id'];
    question = data['question'];
    corretAnswer = data['corret_answer'];
    wrongAnswers = data['wrong_answers'];
    multipleChoice = data['multiple_choice'];
  }
}