import 'package:app_criancas/services/database.dart';
import 'package:app_criancas/widgets/color_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home_screen.dart';

class UserData extends StatefulWidget {
  final FirebaseUser user;
  UserData({this.user});

  @override
  _UserDataState createState() => _UserDataState(user: user);
}

class _UserDataState extends State<UserData> {

  final FirebaseUser user;
  _UserDataState({this.user});

  DateTime _dateTime;
  String _genero;
  String _idade;
  String _grauParentesco;
  String _idadeEE;
  String _profissaoEE;
  String _habilitacoesEE;
  String _nacionalidadeEE;
  String _idadeMae;
  String _profissaoMae;
  String _habilitacoesMae;
  String _nacionalidadeMae;
  String _idadePai;
  String _profissaoPai;
  String _habilitacoesPai;
  String _nacionalidadePai;
  String _idadeIngresso;
  String _nacionalidade;
  String _maisInfo;
  bool _frequentouPre;
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    //Lista de steps
    List<Step> steps = [
      Step(
        title: const Text('Dados do Aluno'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text("Escolha a data de nascimento:"),
                new Padding(padding: EdgeInsets.all(20)),
                new IconButton(
                  icon: Icon(FontAwesomeIcons.calendarDay),
                  color: parseColor("320a5c"),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate:
                                _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(2005),
                            lastDate: DateTime(2021))
                        .then((date) {
                      setState(() {
                        _dateTime = date;
                        var idadeTemp = DateTime.now().difference(date);
                        _idade = (idadeTemp.inSeconds / (365 * 24 * 60 * 60))
                            .toString()
                            .split('.')[0];
                      });
                    });
                  },
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new Text(_dateTime == null
                    ? ''
                    : _dateTime.toString().split(' ')[0]),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    value: 'Masculino',
                    groupValue: _genero,
                    onChanged: (String g) {
                      setState(() {
                        _genero = g;
                      });
                    }),
                new Text('Masculino'),
                Radio(
                    value: "Feminino",
                    groupValue: _genero,
                    onChanged: (String g) {
                      setState(() {
                        _genero = g;
                      });
                    }),
                new Text('Feminino'),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText: _idade == null
                      ? 'Insira a sua idade'
                      : 'exemplo: ' + _idade.toString()),
              onChanged: (String idade) {
                setState(() {
                  _idade = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  _nacionalidade = nacionalidade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade de ingresso no 1o ciclo',
                  hintText: 'exemplo: 6'),
              onChanged: (String idade) {
                setState(() {
                  _idadeIngresso = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText:
                      'Estás envolvido em atividades extracurriculares (exemplo: teatro, desporto)? Se sim, qual/quais?'),
              onChanged: (String maisInfo) {
                setState(() {
                  _maisInfo = maisInfo;
                });
              },
            ),
            Row(
              children: <Widget>[
                Text('Frequentaste pré-escola/jardim de infância:'),
                Padding(padding: EdgeInsets.all(20)),
                Radio(
                    value: true,
                    groupValue: _frequentouPre,
                    onChanged: (bool g) {
                      setState(() {
                        _frequentouPre = g;
                      });
                    }),
                new Text('Sim'),
                Radio(
                    value: false,
                    groupValue: _frequentouPre,
                    onChanged: (bool g) {
                      setState(() {
                        _frequentouPre = g;
                      });
                    }),
                new Text('Não'),
              ],
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Dados do Encarregado de Educação'),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Radio(
                    value: 'Mae',
                    groupValue: _grauParentesco,
                    onChanged: (String g) {
                      setState(() {
                        _grauParentesco = g;
                      });
                    }),
                new Text('Mãe'),
                Radio(
                    value: "Pai",
                    groupValue: _grauParentesco,
                    onChanged: (String g) {
                      setState(() {
                        _grauParentesco = g;
                      });
                    }),
                new Text('Pai'),
                Radio(
                    value: "Outro",
                    groupValue: _grauParentesco,
                    onChanged: (String g) {
                      setState(() {
                        _grauParentesco = g;
                      });
                    }),
                new Text('Outro'),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText:
                      _idadeEE == null ? 'Insira a sua idade' : 'exemplo: 39'),
              onChanged: (String idade) {
                setState(() {
                  _idadeEE = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  _nacionalidadeEE = nacionalidade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profissão',
              ),
              onChanged: (String idade) {
                setState(() {
                  _profissaoEE = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Habilitações Académicas'),
              onChanged: (String maisInfo) {
                setState(() {
                  _habilitacoesEE = maisInfo;
                });
              },
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Dados da Mãe'),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText:
                      _idadeMae == null ? 'Insira a sua idade' : 'exemplo: 39'),
              onChanged: (String idade) {
                setState(() {
                  _idadeMae = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  _nacionalidadeMae = nacionalidade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profissão',
              ),
              onChanged: (String profissao) {
                setState(() {
                  _profissaoMae = profissao;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Habilitações Académicas'),
              onChanged: (String maisInfo) {
                setState(() {
                  _habilitacoesMae = maisInfo;
                });
              },
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Dados do Pai'),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText:
                      _idadePai == null ? 'Insira a sua idade' : 'exemplo: 39'),
              onChanged: (String idade) {
                setState(() {
                  _idadePai = idade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  _nacionalidadePai = nacionalidade;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profissão',
              ),
              onChanged: (String profissao) {
                setState(() {
                  _profissaoPai = profissao;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Habilitações Académicas'),
              onChanged: (String maisInfo) {
                setState(() {
                  _habilitacoesPai = maisInfo;
                });
              },
            ),
          ],
        ),
      ),
    ];

    bool complete = false;
    goTo(int step) {
      setState(() => currentStep = step);
    }

    next() {
      if (currentStep == 0) {
        if (_dateTime == null ||
            _idade == null ||
            _idadeIngresso == null ||
            _genero == null ||
            _nacionalidade == null ||
            _maisInfo == null) {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  content: new Text(
                    "Preencha todos os campos!",
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    ),
                  ),
                  actions: <Widget>[
                    new MaterialButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      color: parseColor("#320a5c"),
                      child: new Text(
                        'Okay',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                );
              });
        } else {
          currentStep + 1 != steps.length
              ? goTo(currentStep + 1)
              : setState(() => complete = true);
        }
      } else if (currentStep == 1) {
        if (_idadeEE == null ||
            _nacionalidadeEE == null ||
            _habilitacoesEE == null ||
            _grauParentesco == null ||
            _profissaoEE == null) {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  content: new Text(
                    "Preencha todos os campos!",
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    ),
                  ),
                  actions: <Widget>[
                    new MaterialButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      color: parseColor("#320a5c"),
                      child: new Text(
                        'Okay',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                );
              });
        } else {
          if (_grauParentesco == 'Pai') {
            _habilitacoesPai = _habilitacoesEE;
            _idadePai = _idadeEE;
            _nacionalidadePai = _nacionalidadeEE;
            _profissaoPai = _profissaoEE;
            currentStep + 1 != steps.length
              ? goTo(currentStep + 1)
              : setState(() => complete = true);
          } else if (_grauParentesco == 'Mae') {
            _habilitacoesMae = _habilitacoesEE;
            _idadeMae = _idadeEE;
            _nacionalidadeMae = _nacionalidadeEE;
            _profissaoMae = _profissaoEE;
            currentStep + 1 != steps.length
              ? goTo(currentStep + 2)
              : setState(() => complete = true);
          }else{
            currentStep + 1 != steps.length
              ? goTo(currentStep + 1)
              : setState(() => complete = true);
          }
        }
      } else if (currentStep == 2) {
        if (_habilitacoesMae == null ||
            _idadeMae == null ||
            _nacionalidadeMae == null ||
            _profissaoMae == null) {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  content: new Text(
                    "Preencha todos os campos!",
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    ),
                  ),
                  actions: <Widget>[
                    new MaterialButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      color: parseColor("#320a5c"),
                      child: new Text(
                        'Okay',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                );
              });
        }else{
          if(_grauParentesco=='Pai'){
            updateUserData(user.email,_idade, _genero, _dateTime, _frequentouPre, _idadeIngresso, _maisInfo, _nacionalidade, _nacionalidadeEE, _grauParentesco, _habilitacoesEE, _idadeEE, _profissaoEE, _profissaoMae, _idadeMae, _nacionalidadeMae, _habilitacoesMae, _idadePai, _nacionalidadePai, _profissaoPai, _habilitacoesPai);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
          }
          currentStep + 1 != steps.length
              ? goTo(currentStep + 1)
              : setState(() => complete = true);
          
        }
      } else if (currentStep == 3) {
        if (_habilitacoesPai == null ||
            _idadePai == null ||
            _nacionalidadePai == null ||
            _profissaoPai == null) {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  content: new Text(
                    "Preencha todos os campos!",
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Amatic SC',
                      letterSpacing: 4,
                    ),
                  ),
                  actions: <Widget>[
                    new MaterialButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      color: parseColor("#320a5c"),
                      child: new Text(
                        'Okay',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Amatic SC',
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                );
              });
        }else{
          updateUserData(user.email,_idade, _genero, _dateTime, _frequentouPre, _idadeIngresso, _maisInfo, _nacionalidade, _nacionalidadeEE, _grauParentesco, _habilitacoesEE, _idadeEE, _profissaoEE, _profissaoMae, _idadeMae, _nacionalidadeMae, _habilitacoesMae, _idadePai, _nacionalidadePai, _profissaoPai, _habilitacoesPai);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
                  }
                }
              }
          
              cancel() {
                if (currentStep > 0) {
                  goTo(currentStep - 1);
                }
                else if (currentStep ==3 &&  _grauParentesco =='Mae' ){
                  goTo(currentStep - 2);
                }
              }
          
              return new Scaffold(
                  appBar: AppBar(
                    title: Text('Create an account'),
                  ),
                  body: Column(children: <Widget>[
                    Expanded(
                      child: Stepper(
                        steps: steps,
                        currentStep: currentStep,
                        onStepContinue: next,
                        onStepTapped: (step) => goTo(step),
                        onStepCancel: cancel,
                      ),
                    ),
                  ]));
            }
}
