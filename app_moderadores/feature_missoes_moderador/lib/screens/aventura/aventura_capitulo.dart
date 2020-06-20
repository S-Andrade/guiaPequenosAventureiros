import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_missoes_moderador/screens/capitulo/capitulo.dart';
import 'package:feature_missoes_moderador/screens/historia/historia.dart';
import 'package:feature_missoes_moderador/services/database.dart';
import 'package:feature_missoes_moderador/services/missions_api.dart';
import 'package:feature_missoes_moderador/widgets/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'aventura.dart';
import '../capitulo/capitulo_list.dart';

class AventuraCapitulo extends StatefulWidget {
  Aventura aventura;
  AventuraCapitulo({this.aventura});

  @override
  _AventuraCapitulo createState() => _AventuraCapitulo(aventura: aventura);
}

class _AventuraCapitulo extends State<AventuraCapitulo> {
  Aventura aventura;
  _AventuraCapitulo({this.aventura});

  List capitulos_historia;
  List capitulos_bd;
  Historia historia;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<Capitulo>>.value(
              value: DatabaseService().capitulo),
        ],
        child: Builder(builder: (BuildContext context) {
          return FutureBuilder<void>(
              future: getCapitulos(context),
              builder: (context, AsyncSnapshot<void> snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/19.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          left: 170,
                        ),
                        child: FlatButton(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, bottom: 30),
                        child:
                            Container(child: CapituloList(aventura: aventura)),
                      ),
                    ]),
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FloatingActionButton(
                        onPressed: () async {
                          await addCapitulo(context);
                        },
                        child: Icon(Icons.add),
                        backgroundColor: const Color(0xff72d8bf),
                      ),
                    ),
                  ),
                );
              });
        }));
  }

  addCapitulo(BuildContext context) async {
    await getHistoria();
    await getCapitulos(context);

    int nome_capitulo = -1;
    if (historia.capitulos.isNotEmpty) {
      List<int> capitulos_historia = [];
      for (String c in historia.capitulos) {
        DocumentReference documentReference =
            Firestore.instance.collection("capitulo").document(c);
        await documentReference.get().then((datasnapshot) async {
          if (datasnapshot.exists) {
            int nome = datasnapshot.data['nome'];
            capitulos_historia.add(nome);
          }
        });
      }
      capitulos_historia.sort();
      nome_capitulo = capitulos_historia.last + 1;
    }

    List ids_c = [];
    for (Capitulo c in capitulos_bd) {
      ids_c.add(int.parse(c.id));
    }
    ids_c.sort();
    var id = (ids_c.last + 1).toString();
    List<dynamic> turmas=await getTurmas(aventura.id);
    Map disponibilidade={};
     turmas.forEach((turma) {
    
    disponibilidade[turma] = false;
    
  });
    DatabaseService().updateCapituloData(id, true, [], nome_capitulo, disponibilidade);
    List novos_capitulos = historia.capitulos;
    novos_capitulos.add(id);
    DatabaseService().updateHistoriaData(
        historia.id, historia.titulo, novos_capitulos, historia.capa);
    print("NOVO CAPITULO CRIADO");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AventuraCapitulo(aventura: aventura)));
  }

  getHistoria() async {
    DocumentReference documentReference =
        Firestore.instance.collection("historia").document(aventura.historia);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        historia = Historia(
          id: datasnapshot.data['id'].toString() ?? '',
          titulo: datasnapshot.data['titulo'].toString() ?? '',
          capitulos: datasnapshot.data['capitulos'] ?? [],
          capa: datasnapshot.data['capa'] ?? '',
        );
      } else {
        print("No such historia");
      }
    });

    capitulos_historia = historia.capitulos;
  }

  getCapitulos(BuildContext context) {
    capitulos_bd = Provider.of<List<Capitulo>>(context, listen: false);
  }
}
