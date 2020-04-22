
import 'package:flutter/material.dart';
import '../../responsive/orientation_layout.dart';
import '../login/login_screen_tablet.dart';
import '../../responsive/screen_type_layout.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      tablet: OrientationLayout(
        portrait: LoginTabletPortrait(),
        landscape: LoginTabletPortrait(),
      ),
    );
  }
}