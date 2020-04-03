class Quiz{
  int result;
  List questions;

  Quiz();

  Quiz.fromMap(Map<String, dynamic> data){
    result = data['result'];
    questions = data['questions'];
  }

   Map<String, dynamic> toMap() {
    return {
      'result':result,
      'questions':questions,
    };
  }
}