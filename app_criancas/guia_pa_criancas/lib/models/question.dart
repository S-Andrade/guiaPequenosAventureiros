

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
  }

  List sortedListAnswers (){
    allAnswers = [];
    allAnswers.addAll(this.wrongAnswers);
    allAnswers.add(this.correctAnswer);
    return allAnswers;
  }

}