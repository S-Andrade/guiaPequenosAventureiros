
import 'package:flutter/material.dart';
import '../login/login_screen_tablet.dart';
import '../../responsive/orientation_layout.dart';
import '../../responsive/screen_type_layout.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: LoginTabletPortrait(),
        landscape: LoginTabletLandscape(),
      ),
    );
  }
}