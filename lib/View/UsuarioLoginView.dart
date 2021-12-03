import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/View/AvisoListagemView.dart';
import 'UsuarioRegistroView.dart';

class LoginUsuario extends StatefulWidget {


  LoginUsuario({Key? key}) : super(key: key);

  @override
  _LoginUsuarioState createState() => _LoginUsuarioState();
}

class _LoginUsuarioState extends State<LoginUsuario> {
  final _formKey = GlobalKey<FormState>();
  UsuarioModel user = new UsuarioModel();
  UsuarioController uc = new UsuarioController();
  final _cpf = TextEditingController();
  final _senha = TextEditingController();
  String cpf='';
  String senha='';
  bool _mostrarSenha = false;

  @override
  void dispose(){
    _cpf.dispose();
    _senha.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Acesso ao Sistema",
        ),
        leading: GestureDetector(
          // child: Icon(
          //   Icons.menu
          // ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black87,
                        style: TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black87
                          ),
                          labelText: 'CPF',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.black87,
                          ),
                        ),
                        controller: _cpf,
                        validator: (String? value){
                          if(value == null || value.isEmpty){
                            return "CPF Obrigatorio";
                          }
                          if(!UtilBrasilFields.isCPFValido(value)){
                            return "CPF Inválido";
                          }
                          cpf = value.replaceAll(new RegExp(r'[^0-9]'),'');
                          user.cpf = cpf;
                          return null;
                        },
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        obscureText: _mostrarSenha ? false : true,
                        cursorColor: Colors.black87,
                        style: TextStyle(
                          color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1.0)
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black87
                          ),
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black87,
                          ),
                          suffixIcon: GestureDetector(
                            child: Icon( _mostrarSenha == false ? Icons.visibility_off : Icons.visibility, color: Colors.black87),
                            onTap: (){
                              setState(() {
                                _mostrarSenha = !_mostrarSenha;
                              });
                            },
                          )
                        ),
                        controller: _senha,
                        validator: (String? value){
                          if(value == null || value.isEmpty){
                            return "Senha Obrigatorio";
                          }
                          senha = value;
                          return null;
                        },
                      ),
                      SizedBox(height: 25,),
                      ElevatedButton(onPressed: () {
                        var formValid = _formKey.currentState?.validate() ?? false;
                        if(formValid){
                          uc.buscaIdUsuarioCPF(user).then((value) =>
                          {
                            user = value,
                            if(user.senha == senha){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Acesso realizado com sucesso."),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                              )),
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AvisosListagem(user)))
                            }else if(user.senha != senha){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("CPF e senha não conferem."),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ))
                            }
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Confira os dados informados."),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            minimumSize: Size(MediaQuery.of(context).size.width, 50)
                        ),
                        child: Text("ENTRAR")),
                      SizedBox(height: 25,),
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistroUsuario() ));
                      },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              minimumSize: Size(MediaQuery.of(context).size.width, 50)
                          ),
                          child: Text("CADASTRAR")),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




