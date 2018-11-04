import 'package:learnable/ui/pages/home_page.dart';
import 'package:learnable/ui/pages/login_page.dart';
import 'package:learnable/ui/pages/about_page.dart';
import 'package:learnable/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';

final routes = {
  "/login":(BuildContext context) => LoginPage(),
  "/home":(BuildContext context) => HomePage(),
  "/about":(BuildContext context) => AboutPage(),
  "/account":(BuildContext context) => ProfilePage(),
};