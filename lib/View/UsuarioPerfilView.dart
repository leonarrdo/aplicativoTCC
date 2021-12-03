import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Controller/EnderecoController.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/Model/EnderecoModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/Model/UsuarioPerfilModel.dart';
import 'package:untitled/View/AvisoListagemView.dart';
import 'package:untitled/services/ViaCepService.dart';

//ignore: must_be_immutable
class UsuarioPerfil extends StatefulWidget {

  UsuarioModel user = new UsuarioModel();
  UsuarioPerfil(this.user);

  @override
  _UsuarioPerfilState createState() => _UsuarioPerfilState();
}

class _UsuarioPerfilState extends State<UsuarioPerfil> {
  
   UsuarioModel usuario = new UsuarioModel();

   @override
  void initState(){
    super.initState();
    usuario = widget.user;
  }
  String cep = '';
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
  late Future<String> dados;
  bool _mostrarSenha = false;

   UsuarioPerfilModel usuarioPerfil = new UsuarioPerfilModel();


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
        title: Text("Editar Perfil",),
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
          child: FutureBuilder(
            future: uc.getUsuarioEndereco(usuario).then((value) {
              usuarioPerfil = value;
              _nome.text = usuarioPerfil.nome.toString();
              _email.text = usuarioPerfil.email.toString();
              _cep.text = usuarioPerfil.cep.toString();
              _cpf.text = usuario.cpf.toString();
              _senha.text = usuarioPerfil.senha.toString();
              _telefone.text = UtilBrasilFields.obterTelefone(usuarioPerfil.telefone.toString());
            }),
            builder: (BuildContext context, AsyncSnapshot dados){
              if(usuarioPerfil.idusuario != null ){
                return Column(
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
                                    color: Colors.black87,
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
                                    return "Nome Obrigatorio";
                                  }
                                  usuario.nome = value;
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
                                    usuario.email = val.toString();

                                  }
                              ), SizedBox(height: 15,),
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
                                  if(telefone.length<8){
                                    return "Telefone deve ter pelo menos 8 digitos";
                                  }
                                },
                              ),
                              SizedBox(height: 15,),
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
                                  if(value != '' && value!=null){
                                    usuario.senha = _senha.text.toString();
                                  }
                                },
                              ),
                              SizedBox(height: 15,),
                              ElevatedButton(onPressed: () {
                                var formValid = _formKey.currentState?.validate() ?? false;
                                if(formValid){
                                  usuario.cpf = UtilBrasilFields.removeCaracteres(_cpf.text);
                                  uc.updateUsuario(usuario).then((value) => {
                                      _searchCep()
                                  });
                                }
                              },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal,
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                      minimumSize: Size(MediaQuery.of(context).size.width, 50)
                                  ),
                                  child: Text("ALTERAR")),
                            ],
                          )
                      ),
                    )
                  ],
                );
              }else{
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Carregando Perfil',
                          style: TextStyle(
                              color: Colors.teal
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
  Future _searchCep() async {

    cep = UtilBrasilFields.removeCaracteres(_cep.text);

    ViaCepService.fetchCep(cep).then((value) => _result = value.toJson()); _validaCEP();
  }

   _validaCEP() {

    if(_result.isNotEmpty) {
      var cep = jsonDecode(_result);

      if (cep['localidade'] == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("CEP inválido"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ));
      }
      if (cep['uf'] != 'GO') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Por favor informe um cep do estado de Goiás"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ));
      }
      if (cep['localidade'] != '' && cep['uf'] == 'GO') {
        endereco.logradouro = cep['localidade'];
        endereco.cep = cep['cep'];
        endereco.telefone = UtilBrasilFields.removeCaracteres(_telefone.text);
        endereco.endereco = cep['logradouro'];
        endereco.idEndereco = usuarioPerfil.idendereco;

        ec.updateEndereco(endereco).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Perfil atualizado com sucesso."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ));
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvisosListagem(usuario)));
        });
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Perfil atualizado com sucesso."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ));
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvisosListagem(usuario)));
    }
   }

}
