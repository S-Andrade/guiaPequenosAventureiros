import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';

class QuestionarioQuestionExist extends StatefulWidget {
  @override
  _QuestionarioQuestionExistState createState() =>
      new _QuestionarioQuestionExistState();
}

class _QuestionarioQuestionExistState extends State<QuestionarioQuestionExist> {
  var isSelected = false;
  var mycolor = Colors.white;
  @override
  void initState(){
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context, listen: false);
    getQuestions(missionsNotifier);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MissionsNotifier missionsNotifier = Provider.of<MissionsNotifier>(context);
    List questions = missionsNotifier.allQuestions;
    return Scaffold(
      body: ListView.separated(itemBuilder: null, separatorBuilder: null, itemCount: null),
    );
  }
}
