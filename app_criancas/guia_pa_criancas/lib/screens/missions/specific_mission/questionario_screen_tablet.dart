import 'package:app_criancas/models/mission.dart';
import 'package:flutter/cupertino.dart';

class QuestionarioScreen extends StatefulWidget{
  final Mission mission;

  QuestionarioScreen(this.mission);
  @override
  _QuestionarioScreenState createState() =>_QuestionarioScreenState(mission);
}

class _QuestionarioScreenState extends State<QuestionarioScreen>{
  Mission mission;
  _QuestionarioScreenState(this.mission);

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return null;
  }
  
}
