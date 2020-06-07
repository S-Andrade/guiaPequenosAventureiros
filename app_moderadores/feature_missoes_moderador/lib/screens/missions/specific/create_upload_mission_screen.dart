import 'dart:async';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo_details.dart';
import 'package:feature_missoes_moderador/screens/tab/tab.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:feature_missoes_moderador/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/screens/aventura/aventura.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';

class CreateUploadMissionScreen extends StatefulWidget {
  Aventura aventuraId;
  Capitulo capitulo;

  CreateUploadMissionScreen({this.capitulo, this.aventuraId});

  @override
  _CreateUploadMissionScreenState createState() =>
      _CreateUploadMissionScreenState(
          capitulo: this.capitulo, aventuraId: this.aventuraId);
}

class _CreateUploadMissionScreenState extends State<CreateUploadMissionScreen> {
  _CreateUploadMissionScreenState({this.capitulo, this.aventuraId});

  String _titulo;
  String _descricao;

  Aventura aventuraId;
  Capitulo capitulo;
final _textPontos = TextEditingController();
  String _pontos;
  final _text = TextEditingController();
  final _text2 = TextEditingController();
  bool _loaded;
  String uploadType = '';

  @override
  void initState() {
    _loaded = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                image: AssetImage("assets/images/30.jpg"),
                fit: BoxFit.cover,
              ),
            ),
                 
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 50.0, bottom: 5.0),
                            child: Text(
                              "Pedir uma submissão",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
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
                              "As crianças irão receber uma missão, na qual terão de submeter uma imagem ou vídeo, segundo o que lhes é pedido.",
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
                            color: parseColor("F4F19C"),
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
                  padding: EdgeInsets.only(top: 50.0, left: 70.0, bottom: 30.0),
                  child: Column(
                    children: <Widget>[
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
                                  color:parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  controller: _text2,
                                  onChanged: (value) {
                                    _titulo = value;
                                  },
                                  maxLength: 40,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
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
                      SizedBox(height: 50.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  "Descrição",
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
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: parseColor("F4F19C"),
                                ),
                                child: TextField(
                                  controller: _text,
                                  onChanged: (value) {
                                    _descricao = value;
                                  },
                                  maxLength: 70,
                                  maxLengthEnforced: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                     fontWeight: FontWeight.w900,
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 15),
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[50],
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Insira uma breve descriçao",
                                    fillColor: Colors.blue[50],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 30.0),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 320.0,
                                child: Text(
                                  "Tipo de ficheiro a submeter:",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                   
                                      fontFamily: 'Monteserrat',
                                      letterSpacing: 2,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              GestureDetector(
                                onTap: () => setState(() => uploadType = "image"),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border:
                                        Border.all(color: parseColor("#320a5c")),
                                    color: uploadType == "image"
                                        ? parseColor("F4F19C")
                                        : Colors.transparent,
                                  ),
                                  height: 70,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Imagem",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Amatic SC',
                                          letterSpacing: 4,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => setState(() => uploadType = "video"),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border:
                                        Border.all(color: parseColor("#320a5c")),
                                    color: uploadType == "video"
                                        ? parseColor("F4F19C")
                                        : Colors.transparent,
                                  ),
                                  height: 70,
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Vídeo",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Amatic SC',
                                          letterSpacing: 4,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 50.0),
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
                            onPressed: () {
                              if (_text.text.length > 0 &&
                                  _text2.text.length > 0 &&
                                  uploadType != "" && _textPontos.text.length>0)
                                showConfirmar(context, _titulo, _descricao,int.parse(_pontos));
                              else
                                showError(context);
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showError(BuildContext context) {
    // configura o button

    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text(
        "Por favor preencha todos os campos!",
        style: TextStyle(
            color: Colors.black,
          
            fontFamily: 'Monteserrat',
            letterSpacing: 2,
            fontSize: 20),
      ),
    );

    // exibe o dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alerta;
      },
    );
    Timer(Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  showConfirmar(BuildContext context, String titulo, String conteudo,int pontos) {
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
        if (uploadType == "image")
          createMissionUploadImageInFirestore(
              titulo, _descricao, aventuraId.id, capitulo.id,pontos);
        else if (uploadType == "video")
          createMissionUploadVideoInFirestore(
              titulo, _descricao, aventuraId.id, capitulo.id,pontos);

        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CapituloDetails(
                                    capitulo: capitulo, aventura: aventuraId)));
      },
    );

    popup.show(
      close:Container(),
      title: Text(
        "o",
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
