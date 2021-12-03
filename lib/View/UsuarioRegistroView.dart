import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Controller/EnderecoController.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/Model/EnderecoModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/View/UsuarioLoginView.dart';
import 'package:untitled/services/ViaCepService.dart';


class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({Key? key}) : super(key: key);

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {

  final UsuarioModel user = new UsuarioModel();
  late UsuarioModel u = new UsuarioModel();
  final EnderecoModel endereco = new EnderecoModel();
  final UsuarioController uc = new UsuarioController();
  final EnderecoController ec = new EnderecoController();
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _cpf = TextEditingController();
  final _telefone = TextEditingController();
  final _senha = TextEditingController();
  final _cep = TextEditingController();
  late String _result="";
  late String erro ="";
  bool _mostrarSenha = false;

  @override
  void dispose(){
    _nome.dispose();
    _email.dispose();
    _cpf.dispose();
    _senha.dispose();
    _cep.dispose();
    _telefone.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Registro de Usuário",),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          // reverse: true,
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(2, 20, 2, 2),
                child: Form(
                  // autovalidateMode: AutovalidateMode,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.black87,
                        style: TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black87,
                          ),
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.black87,
                          ),
                        ),
                        controller: _nome,
                        validator: (String? value){
                          if(value == null || value.isEmpty){
                            return "Nome Obrigatório.";
                          }
                          user.nome = value;
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
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
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black87,
                          ),
                        ),
                        controller: _email,
                        validator: (val) {
                          if(val!.isEmpty || !val.contains("@") || val.length < 10 ){
                              return "Informe um email válido.";
                          }
                          user.email = val.toString();

                        }
                      ),
                      SizedBox(height: 15,),
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
                            Icons.assignment_sharp,
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
                          user.cpf = value.replaceAll(new RegExp(r'[^0-9]'),'');
                          return null;
                        },
                      ),SizedBox(height: 15,),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter()
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
                          labelText: 'CEP',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.house,
                            color: Colors.black87,
                          ),
                        ),
                        controller: _cep,
                        validator: (String? value){
                          if(value == null || value.isEmpty){
                            return "CEP Obrigatorio";
                          }
                        },
                      ),SizedBox(height: 15,),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
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
                          labelText: 'Telefone',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.black87,
                          ),
                        ),
                        controller: _telefone,
                        validator: (String? value){
                          var telefone = UtilBrasilFields.removeCaracteres(_telefone.text);
                          if(value == null || value.isEmpty){
                            return "Telefone obrigatorio";
                          }
                          if(telefone.length<11){
                            return "Telefone deve pelo menos 11 digitos";
                          }
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        cursorColor: Colors.black87,
                        obscureText: _mostrarSenha ? false : true,
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
                            return "Senha Obrigatório.";
                          }
                          user.senha = value;
                        },
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(onPressed: () {
                        var formValid = _formKey.currentState?.validate() ?? false;
                        if(formValid){
                          user.cpf = UtilBrasilFields.removeCaracteres(_cpf.text);
                          uc.buscaIdUsuarioCPF(user).then((value) => {
                            u = value,
                            if(u.idusuario==null){
                              _searchCep()
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("CPF já cadastrado no sistema."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 4),
                              )),

                            }
                          });
                        }
                      },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              minimumSize: Size(MediaQuery.of(context).size.width, 50)
                          ),
                          child: Text("CADASTRAR")),
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future _searchCep() async {

    final cep = UtilBrasilFields.removeCaracteres(_cep.text);

    ViaCepService.fetchCep(cep).then((value) => _result = value.toJson()); _validaCEP();
  }

   _validaCEP() {


    if(_result.isNotEmpty){
      var cep = jsonDecode(_result);

      if(cep['localidade'] == ''){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("CEP inválido"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ));
      }
      if(cep['uf'] != 'GO'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Por favor informe um cep do estado de Goiás"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ));
      }
      if(cep['localidade'] != '' && cep['uf'] == 'GO'){
        endereco.logradouro = cep['localidade'];
        endereco.cep = cep['cep'];
        endereco.telefone = UtilBrasilFields.removeCaracteres(_telefone.text);
        endereco.endereco = cep['logradouro'];

        print("Cidade:${endereco.logradouro}");

        ec.inserir(endereco, user).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Usuário cadastrado com sucesso."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ));
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginUsuario() ));
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erro ao buscar dados do CEP, tente novamente."),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ));
    }

  }

}
