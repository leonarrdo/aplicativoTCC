import 'package:flutter/material.dart';

import 'View/UsuarioLoginView.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tela de Login",
      // theme: ThemeData(primaryColor: Colors.red),
      home: LoginUsuario(),
    );
  }
}

