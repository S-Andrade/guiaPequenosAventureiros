import 'package:app_criancas/widgets/color_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
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
        state: StepState.complete,
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
                        print(_idade);
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
        state: StepState.disabled,
        content: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Radio(
                    value: 'Mãe',
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
        title: const Text('Dados da Familia'),
        isActive: false,
        state: StepState.disabled,
        content: Column(
          children: <Widget>[
            Text('Dados da Mãe'),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText:
                      _idadeMae == null ? 'Insira a sua idade' : 'exemplo: 39'),
              onChanged: (String idade) {
                setState(() {
                  if (_grauParentesco == 'Mae') {
                    _idadeMae = _idadeEE;
                  } else {
                    _idadeMae = idade;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  if (_grauParentesco == 'Mae') {
                    _nacionalidadeMae = _nacionalidadeEE;
                  } else {
                    _nacionalidadeMae = _nacionalidade;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profissão',
              ),
              onChanged: (String profissao) {
                setState(() {
                  if (_grauParentesco == 'Mae') {
                    _profissaoMae = _profissaoEE;
                  } else {
                    _profissaoMae = profissao;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Habilitações Académicas'),
              onChanged: (String maisInfo) {
                setState(() {
                  if (_grauParentesco == 'Mae') {
                    _habilitacoesMae = _habilitacoesEE;
                  } else {
                    _habilitacoesMae = maisInfo;
                  }
                });
              },
            ),
            Text('Dados da Pai'),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Idade',
                  hintText:
                      _idadePai == null ? 'Insira a sua idade' : 'exemplo: 39'),
              onChanged: (String idade) {
                setState(() {
                  if (_grauParentesco == 'Pai') {
                    _idadePai = _idadeEE;
                  } else {
                    _idadePai = idade;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nacionalidade', hintText: 'exemplo: Portuguesa'),
              onChanged: (String nacionalidade) {
                setState(() {
                  if (_grauParentesco == 'Pai') {
                    _nacionalidadePai = _nacionalidadeEE;
                  } else {
                    _nacionalidadePai = _nacionalidade;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profissão',
              ),
              onChanged: (String profissao) {
                setState(() {
                  if (_grauParentesco == 'Pai') {
                    _profissaoPai = _profissaoEE;
                  } else {
                    _profissaoPai = profissao;
                  }
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Habilitações Académicas'),
              onChanged: (String maisInfo) {
                setState(() {
                  if (_grauParentesco == 'Mae') {
                    _habilitacoesPai = _habilitacoesEE;
                  } else {
                    _habilitacoesPai = maisInfo;
                  }
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
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() => complete = true);
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
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
