import 'dart:async';
import 'package:feature_missoes_moderador/models/question.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'create_questionario_question_screen.dart';
import 'exist_question.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';

class CreateQuestionarioMissionScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;
  CreateQuestionarioMissionScreen(this.capitulo, this.aventuraId);

  @override
  _CreateQuestionarioMissionScreenState createState() =>
      _CreateQuestionarioMissionScreenState(this.capitulo, this.aventuraId);
}

class _CreateQuestionarioMissionScreenState
    extends State<CreateQuestionarioMissionScreen> {
  Capitulo capitulo;
  Aventura aventuraId;
  String _titulo;
  final _textPontos = TextEditingController();
  String _pontos;
  List<Question> _perguntas;
  List<Question> selectedQ = [];

  final _text = TextEditingController();

  _CreateQuestionarioMissionScreenState(this.capitulo, this.aventuraId);

  @override
  void initState() {
    _titulo = "";
    _perguntas = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (missionNotifier.currentQuestion != null) {
      if (!_perguntas.contains(missionNotifier.currentQuestion)) {
        _perguntas.add(missionNotifier.currentQuestion);
      }
    }
    if (selectedQ.isNotEmpty) {
      selectedQ.forEach((f) {
        if(!_perguntas.contains(f)){
          _perguntas.add(f);
        }
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/24.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 100.0, bottom: 5.0),
                            child: Text(
                              "Criar um Questionario",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Nesta secção, poderão ser criadas as questões para o Questionário.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  fontFamily: 'Amatic SC',
                                  letterSpacing: 4),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          FlatButton(
                            color:parseColor("F4F19C"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Voltar atrás",
                              style: TextStyle(
                                  color: Colors.black,
                                  
                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 50.0, left: 70.0, bottom: 10.0),
                    child: Column(children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  "Título",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                     
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  controller: _text,
                                  onChanged: (value) {
                                    _titulo = value;
                                  },
                                  maxLength: 50,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Insira o título",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                       SizedBox(height: 20.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  "Pontos",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                     
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                  controller: _textPontos,
                                  onChanged: (value) {
                                    _pontos = value;
                                  },
                                  maxLength: 5,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 14),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Insira os pontos que esta missão vale",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),


                      SizedBox(height: 20.0),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                                   BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal
              2.5, // vertical
            ),
                                        )
                                                  ]),
                              child: Column(children: [
                                Container(
                                    height: 320,
                                    width: 700,
                                    child: ListView.separated(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                     icon: Icon(FontAwesomeIcons.check),
                                                iconSize: 20,
                                                color: Colors.blue,
                                                onPressed: null,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0),
                                                    child: Container(
                                                        width: 550,
                                                        child: Row(children: [
                                                          Flexible(
                                                            child: Text(
                                                              _perguntas[index]
                                                                  .question,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  
                                                                  fontFamily:
                                                                      'Monteserrat',
                                                                  letterSpacing:
                                                                      2,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ])),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        FontAwesomeIcons.trash, size: 20,
                                                  color:Colors.red,),
                                                    iconSize: 10,
                                                    color: parseColor("#320a5c"),
                                                    onPressed: () {
                                                      setState(() {
                                                        _perguntas
                                                            .removeAt(index);
                                                        missionNotifier
                                                                .currentQuestion =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                              height: 70,
                                              color: Colors.black12);
                                        },
                                        itemCount: _perguntas.length)),
                                         Container(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                          width: 700,
                                          height: 1,
                                          color: Colors.black),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Adicione aqui cada questão: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Monteserrat',
                                                color: Colors.black,
                                                letterSpacing: 2),
                                          )
                                        ]),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                      child: Icon(FontAwesomeIcons.plus,color: parseColor("#FFCE02"),
                                              size: 30),
                                      onPressed: () {
                                        final popup = BeautifulPopup(
  context: context,
  template: TemplateTerm,
);  
                                        popup.show(
                                              title: Text(""),
                                              close:Container(),
                                              content:
                                              Column(children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom:20.0),
                                                  child: Center(
                                                  child: Row(
                                                                                                      children:[ Flexible(
                                                                                                        child: Text('Quer criar uma questão nova ou utilizar uma já existente de outro Questionário?',style:TextStyle(
                                                        fontSize: 18,
                                                      
                                                        fontFamily: 'Monteserrat',
                                                        color: Colors.black,
                                                        letterSpacing: 2)),
                                                    ),]
                                                  ),
                                              ),
                                                ),
                                                Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: FlatButton(
                                                    child: Text('Nova',style:TextStyle(
                                                  fontSize: 15,
                                             
                                                  fontFamily: 'Monteserrat',
                                                  color: Colors.black,
                                                  letterSpacing: 2),),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateQuestionarioQuestion()));
                                                    },
                                                  ),
                                              ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: FlatButton(
                                                    child: Text(
                                                        'De outro Questionário',style:TextStyle(
                                                  fontSize: 15,
                                            
                                                  fontFamily: 'Monteserrat',
                                                  color: Colors.black,
                                                  letterSpacing: 2)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  QuestionarioQuestionExist(
                                                                      selectedQ)));
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: FlatButton(
                                                    child: Text('Cancelar',style:TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Monteserrat',
                                                  color: Colors.red,
                                                  letterSpacing: 2)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                )],)
                                              
                                            
                                          
                                        );
                                      }),
                                ) ,
                                  ]),
                                ),
                              ]))),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: const Color(0xff72d8bf),
                            onPressed: () async {
                              missionNotifier.currentQuestion = null;
                              if (_text.text.length > 0 &&
                                  _perguntas.length != 0 && _textPontos.text.length>0)
                                showConfirmar(context, _titulo, _perguntas,int.parse(_pontos));
                              else
                                await showError();
                            },
                            child: Text(
                              "Submeter missão",
                              style: TextStyle(
                                  color: Colors.black,

                                  fontFamily: 'Monteserrat',
                                  letterSpacing: 2,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showError() async {

    
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Falta inserir um título ou criar, pelo menos, uma questão!",
        style: TextStyle(
            color: Colors.black,
          
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(BuildContext context, String titulo, List questions,int pontos) {
                     final popup = BeautifulPopup.customize(
  context: context,
  build: (options) => MyTemplateConfirmation(options),
);

    Widget cancelaButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(
            color: Colors.black,
          
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continuaButton = FlatButton(
      child: Text(
        "Sim",
        style: TextStyle(
            color: Colors.black,
      
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      onPressed: () {
        createMissionQuestinario(titulo, questions, aventuraId.id, capitulo.id,pontos);
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) =>
                TabBarMissions(capitulo: capitulo, aventura: aventuraId)));
      },
    );

    popup.show(
      title: Text(
        "",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'Amatic SC',
            letterSpacing: 2,
            fontSize: 30),
      ),
      content: Text(
        "\nTem a certeza que pretende submeter?",
        style: TextStyle(
            color: Colors.black,
           
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
   
  }
}
