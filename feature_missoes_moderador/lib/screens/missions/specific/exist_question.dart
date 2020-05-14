import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/notifier/missions_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';

class QuestionarioQuestionExist extends StatefulWidget {
  
  List<Question> selectedQ;
  QuestionarioQuestionExist(this.selectedQ);
  @override
  _QuestionarioQuestionExistState createState() =>
      new _QuestionarioQuestionExistState(this.selectedQ);
}

class _QuestionarioQuestionExistState extends State<QuestionarioQuestionExist> {
  var isSelected = false;
  var mycolor = Colors.white;
  bool first =true;
  List<Question> selectedQ;
  List selected = [];
  int nSelected = 0;

  _QuestionarioQuestionExistState(this.selectedQ);
 
  @override
  void initState() {
    nSelected = 0;
    MissionsNotifier missionsNotifier =
        Provider.of<MissionsNotifier>(context, listen: false);
    getQuestions(missionsNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    MissionsNotifier missionNotifier =
        Provider.of<MissionsNotifier>(context);
   
    List<Question> questions = missionNotifier.allQuestions;
    selectedQ.forEach((f){
      selected.add(f.question);
    });
    selectedQ.clear();
    questions.forEach((f){
      if(selected.contains(f.question)){
        selectedQ.add(f);
      }
    });
    nSelected = selectedQ.length;
    return Scaffold(
      appBar: AppBar(title: Text('Todas as Perguntas'), actions: <Widget>[
        IconButton(
              icon: Icon(Icons.check_circle_outline),
              onPressed: () {
                setState(() {
                  if(first){
                    questions.forEach((f){
                      if(!selected.contains(f.question)){
                        selectedQ.add(f);
                        selected.add(f.question);
                      }
                    });
                  first = false;
                  }else{
                    selected.clear();
                    selectedQ.clear();
                    first=true;
                  }
                  nSelected = selectedQ.length;
                });
              },
              alignment: Alignment.topRight,
              tooltip: first? 'Clique para adicionar todas as perguntas' : 'Clique pare remover todas',
            ),
      ],),
      body: Column(
        children: <Widget>[
          Container(
            height: 
            400,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Card(
                    color: selectedQ.contains(questions[index]) == true
                        ? Colors.purple
                        : Colors.white,
                    child: ListTile(
                      title: Text(questions[index].question),
                      onTap: () {
                        setState(() {
                          if (selected.contains(questions[index].question)) {
                            selectedQ.remove(questions[index]);
                            selected.remove(questions[index].question);
                          } else {
                            selected.add(questions[index].question);
                            selectedQ.add(questions[index]);
                          }
                          nSelected = selectedQ.length;
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: questions.length),
          ),
          Row(children: <Widget>[
            Text( nSelected!=0 ? 'Selecionou '+nSelected.toString()+' perguntas' : 'Selecione as perguntas que quer adicionar ao Questionario'),
          ],),
          Row(children: <Widget>[
            Center(
              child: FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
              }, child: nSelected!=0 ? Text("Adicionar") : Text('Cancelar'))
            ),
          ],),
        ],
      ),
    );
  }
}
