import 'package:app_criancas/models/companheiro.dart';
import 'package:flutter/material.dart';

class CompanheiroNotifier with ChangeNotifier {
  Companheiro _currentCompanheiro;
  Companheiro get currentCompanheiro => _currentCompanheiro;
  set currentCompanheiro(Companheiro companheiro) {
    _currentCompanheiro = companheiro;
    notifyListeners();
  }
}
