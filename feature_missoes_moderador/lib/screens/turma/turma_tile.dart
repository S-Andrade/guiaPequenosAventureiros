import 'package:flutter/material.dart';
import 'package:feature_missoes_moderador/services/database.dart';
import 'turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../escola/escola.dart';
import '../escola/escola_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../widgets/color_loader.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class TurmaTile extends StatefulWidget {
  String turma;
  Escola escola;
  TurmaTile({this.turma, this.escola});

  @override
  _TurmaTile createState() => _TurmaTile(turma: turma, escola: escola);
}

class _TurmaTile extends State<TurmaTile> {
  String turma;
  Escola escola;
  _TurmaTile({this.turma, this.escola});

  Turma turmafinal;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getTurma(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError)
                return new Text('Erro: ${snapshot.error}');
              else
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  title: Text(turmafinal.nome),
                  trailing: Wrap(
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.file_download),
                          onPressed: () {
                            downloadFile();
                          }), // icon-1
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteTurma(context);
                          }), // icon-2
                    ],
                  ),
                ),
              ),
            );
               
              break;
            default:
              return Container();
          }
          
        });
  }

  Future<void> getTurma() async {
    DocumentReference documentReference =
        Firestore.instance.collection("turma").document(turma);
    await documentReference.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        turmafinal = Turma(
          id: datasnapshot.data['id'].toString() ?? '',
          nome: datasnapshot.data['nome'].toString() ?? '',
          professor: datasnapshot.data['professor'].toString() ?? '',
          nAlunos: datasnapshot.data['nAlunos'] ?? 0,
          alunos: datasnapshot.data['alunos'] ?? [],
          file: datasnapshot.data['file'].toString() ?? '',
        );
        flag = true;
      } else {
        print("No such Turma");
      }
    });
  }

  Future<void> deleteTurma(BuildContext context) async {
    DocumentReference documentReference =
        Firestore.instance.collection("turma").document(turmafinal.id);
    await documentReference.delete();

    List turmas = escola.turmas;
    turmas.remove(turmafinal.id);
    DatabaseService().updateEscolaData(escola.id, escola.nome, turmas);

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(turmafinal.file);

    var url = await firebaseStorageRef.getDownloadURL();

    await deleteUser(url);

    for (String id_aluno in turmafinal.alunos) {
      DocumentReference documentReference =
          Firestore.instance.collection("aluno").document(id_aluno);
      await documentReference.delete();
    }

    await firebaseStorageRef.delete();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EscolaDetails(escola: escola)));
    print(turmafinal.alunos);
  }

  Future<void> deleteUser(String url) async {
    new HttpClient()
        .getUrl(Uri.parse(url))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
      response.transform(new Utf8Decoder()).listen((contents) async {
        List lista = contents.split("\n");
        final FirebaseAuth auth = FirebaseAuth.instance;
        for (String crianca in lista) {
          if (crianca != "") {
            List a = crianca.split(" -> ");
            print(a);
            AuthResult result = await auth.signInWithEmailAndPassword(
                email: a[0].trim(), password: a[1].trim());
            FirebaseUser user = await auth.currentUser();
            user.delete();
          }
        }
      });
    });
  }

  void downloadFile() async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(turmafinal.file);

    var url = await firebaseStorageRef.getDownloadURL();

    bool ready = await _checkPermission();
    if (ready) {
      Directory directory = await DownloadsPathProvider.downloadsDirectory;

      await FlutterDownloader.initialize(debug: true);
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        fileName: '${turmafinal.nome}.txt',
        savedDir: directory.path.toString(),
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
