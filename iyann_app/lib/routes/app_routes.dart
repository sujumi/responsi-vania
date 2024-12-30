import 'package:flutter/material.dart';
import 'package:iyann_app/screens/auth/login_screen.dart';
import 'package:iyann_app/screens/auth/register_screen.dart';
import 'package:iyann_app/screens/home/home_screen.dart';
import 'package:iyann_app/screens/user/user_list_screen.dart';
import 'package:iyann_app/screens/user/user_detail_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String userList = '/users';
  static const String userDetail = '/users/detail';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    userList: (context) => UserListScreen(),
    userDetail: (context) => UserDetailScreen(),
  };
}