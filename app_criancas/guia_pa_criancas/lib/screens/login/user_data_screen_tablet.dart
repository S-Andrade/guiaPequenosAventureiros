import 'package:app_criancas/screens/companheiro/companheiro_creation.dart';
import 'package:app_criancas/services/database.dart';
import 'package:app_criancas/widgets/color_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  DateTime _idadeEE;
  String _profissaoEE;
  String _habilitacoesEE;
  String _nacionalidadeEE;
  DateTime _idadeMae;
  String _profissaoMae;
  String _habilitacoesMae;
  String _nacionalidadeMae;
  DateTime _idadePai;
  String _profissaoPai;
  String _habilitacoesPai;
  String _nacionalidadePai;
  String _idadeIngresso;
  String _nacionalidade;
  String _maisInfo;
  bool _frequentouPre;
  int currentStep = 0;

  final String userDataImg = 'assets/svg/userdata.svg';

  @override
  Widget build(BuildContext context) {
    //Lista de steps
    List<Step> steps = [
      Step(
        title: Text(
          'Dados do Aluno',
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 26,
            color: Color(0xFF100043),
          )),
        ),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Row(
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: <Widget>[
                      Text(
                        'Data de Nascimento: ',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _dateTime == null
                            ? ''
                            : _dateTime.toString().split(' ')[0],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.topCenter,
                        icon: Icon(FontAwesomeIcons.calendarDay),
                        color: parseColor("320a5c"),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate:
                                _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(2005),
                            lastDate: DateTime(2021),
                            locale: const Locale('pt', 'PT'),
                          ).then((date) {
                            setState(() {
                              _dateTime = date;
                              var idadeTemp = DateTime.now().difference(date);
                              _idade =
                                  (idadeTemp.inSeconds / (365 * 24 * 60 * 60))
                                      .toString()
                                      .split('.')[0];
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Radio(
                      value: 'Masculino',
                      groupValue: _genero,
                      onChanged: (String g) {
                        setState(() {
                          _genero = g;
                        });
                      }),
                  Text('Masculino',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ))),
                  Radio(
                      value: "Feminino",
                      groupValue: _genero,
                      onChanged: (String g) {
                        setState(() {
                          _genero = g;
                        });
                      }),
                  Text('Feminino',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Idade',
                    hintText: _idade == null
                        ? 'Insira a sua idade'
                        : 'Exemplo: ' + _idade.toString()),
                onChanged: (String idade) {
                  setState(() {
                    _idade = idade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nacionalidade',
                    hintText: 'exemplo: Portuguesa'),
                onChanged: (String nacionalidade) {
                  setState(() {
                    _nacionalidade = nacionalidade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Idade de ingresso no 1º ciclo',
                    hintText: 'exemplo: 6'),
                onChanged: (String idade) {
                  setState(() {
                    _idadeIngresso = idade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        'Estás envolvido em atividades extracurriculares (exemplo: teatro, desporto)? Se sim, qual/quais?'),
                onChanged: (String maisInfo) {
                  setState(() {
                    _maisInfo = maisInfo;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child:
                          Text('Frequentaste pré-escola/jardim de infância:')),
                  Row(
                    children: <Widget>[
                      Radio(
                          value: true,
                          groupValue: _frequentouPre,
                          onChanged: (bool g) {
                            setState(() {
                              _frequentouPre = g;
                            });
                          }),
                      Text('Sim'),
                      Radio(
                          value: false,
                          groupValue: _frequentouPre,
                          onChanged: (bool g) {
                            setState(() {
                              _frequentouPre = g;
                            });
                          }),
                      Text('Não'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Flexible(
          child: Text(
            'Dados do Encarregado\nde Educação',
            style: GoogleFonts.raleway(
                textStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 26,
              color: Color(0xFF100043),
            )),
          ),
        ),
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Row(
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: <Widget>[
                      Text(
                        'Data de Nascimento: ',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _idadeEE == null
                            ? ''
                            : _idadeEE.toString().split(' ')[0],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.topCenter,
                        icon: Icon(FontAwesomeIcons.calendarDay),
                        color: parseColor("320a5c"),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate:
                                _idadeEE == null ? DateTime.now() : _idadeEE,
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2021),
                            locale: const Locale('pt', 'PT'),
                          ).then((date) {
                            setState(() {
                              _idadeEE = date;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nacionalidade',
                    hintText: 'exemplo: Portuguesa'),
                onChanged: (String nacionalidade) {
                  setState(() {
                    _nacionalidadeEE = nacionalidade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Profissão',
                ),
                onChanged: (String idade) {
                  setState(() {
                    _profissaoEE = idade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Habilitações Académicas'),
                onChanged: (String maisInfo) {
                  setState(() {
                    _habilitacoesEE = maisInfo;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Text(
          'Dados da Mãe',
          style: GoogleFonts.raleway(
              textStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26,
            color: Color(0xFF100043),
          )),
        ),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Row(
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: <Widget>[
                      Text(
                        'Data de Nascimento: ',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _idadeMae == null
                            ? ''
                            : _idadeMae.toString().split(' ')[0],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.topCenter,
                        icon: Icon(FontAwesomeIcons.calendarDay),
                        color: parseColor("320a5c"),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate:
                                _idadeMae == null ? DateTime.now() : _idadeMae,
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2021),
                            locale: const Locale('pt', 'PT'),
                          ).then((date) {
                            setState(() {
                              _idadeMae = date;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nacionalidade',
                    hintText: 'exemplo: Portuguesa'),
                onChanged: (String nacionalidade) {
                  setState(() {
                    _nacionalidadeMae = nacionalidade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Profissão',
                ),
                onChanged: (String profissao) {
                  setState(() {
                    _profissaoMae = profissao;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Habilitações Académicas'),
                onChanged: (String maisInfo) {
                  setState(() {
                    _habilitacoesMae = maisInfo;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Text(
          'Dados do Pai',
          style: GoogleFonts.raleway(
              textStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26,
            color: Color(0xFF100043),
          )),
        ),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Row(
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: <Widget>[
                      Text(
                        'Data de Nascimento: ',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _idadePai == null
                            ? ''
                            : _idadePai.toString().split(' ')[0],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.topCenter,
                        icon: Icon(FontAwesomeIcons.calendarDay),
                        color: parseColor("320a5c"),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate:
                                _idadePai == null ? DateTime.now() : _idadePai,
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2021),
                            locale: const Locale('pt', 'PT'),
                          ).then((date) {
                            setState(() {
                              _idadePai = date;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nacionalidade',
                    hintText: 'exemplo: Portuguesa'),
                onChanged: (String nacionalidade) {
                  setState(() {
                    _nacionalidadePai = nacionalidade;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Profissão',
                ),
                onChanged: (String profissao) {
                  setState(() {
                    _profissaoPai = profissao;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Habilitações Académicas'),
                onChanged: (String maisInfo) {
                  setState(() {
                    _habilitacoesPai = maisInfo;
                  });
                },
              ),
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
          } else {
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
        } else {
          if (_grauParentesco == 'Pai') {
            updateUserData(
                user.email,
                _idade,
                _genero,
                _dateTime,
                _frequentouPre,
                _idadeIngresso,
                _maisInfo,
                _nacionalidade,
                _nacionalidadeEE,
                _grauParentesco,
                _habilitacoesEE,
                _idadeEE,
                _profissaoEE,
                _profissaoMae,
                _idadeMae,
                _nacionalidadeMae,
                _habilitacoesMae,
                _idadePai,
                _nacionalidadePai,
                _profissaoPai,
                _habilitacoesPai);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateCompanheiro()));
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
        } else {
          updateUserData(
              user.email,
              _idade,
              _genero,
              _dateTime,
              _frequentouPre,
              _idadeIngresso,
              _maisInfo,
              _nacionalidade,
              _nacionalidadeEE,
              _grauParentesco,
              _habilitacoesEE,
              _idadeEE,
              _profissaoEE,
              _profissaoMae,
              _idadeMae,
              _nacionalidadeMae,
              _habilitacoesMae,
              _idadePai,
              _nacionalidadePai,
              _profissaoPai,
              _habilitacoesPai);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateCompanheiro()));
        }
      }
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      } else if (currentStep == 3 && _grauParentesco == 'Mae') {
        goTo(currentStep - 2);
      }
    }

    return new Scaffold(
        backgroundColor: Color(0xFFfcfcfe),
//                  appBar: AppBar(
//                    title: Text('Create an account'),
//                  ),
        body: SafeArea(
          child: Theme(
              data: ThemeData(primaryColor: Color(0xFF8a46c6)),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Image(
                          image: AssetImage('assets/images/userdata.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter),
                      Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 300.0),
                          child: Text(
                            'Olá',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Color(0xFF100043),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30.0, left: 30.0, bottom: 30.0),
                          child: Text(
                            'Convidamos a preencher este questionário com o objetivo de avaliarmos a progressão do projeto e o seu impacto na vida escolar dos alunos e alunas de quarto ano.\nSe surgirem dúvidas estamos aqui para esclarecer. É muito importante que responda a todas as perguntas.',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                              fontSize: 22,
                              color: Color(0xFF100043),
                            )),
                          ),
                        ),
                        Container(
                          child: Stepper(
                            physics: ClampingScrollPhysics(),
                            controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) {
                              return Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: onStepContinue,
                                    child: const Text('Próximo'),
                                  ),
                                  FlatButton(
                                    onPressed: onStepCancel,
                                    child: const Text('Anterior'),
                                  ),
                                ],
                              );
                            },
                            steps: steps,
                            currentStep: currentStep,
                            onStepContinue: next,
                            //onStepTapped: (step) => goTo(step),
                            onStepCancel: cancel,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              )),
        ));
  }
}
