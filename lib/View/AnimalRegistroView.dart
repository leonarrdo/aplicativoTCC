import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Controller/AnimalController.dart';
import 'package:untitled/Controller/EspecieController.dart';
import 'package:untitled/Controller/PorteController.dart';
import 'package:untitled/Controller/RacaController.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/Model/AnimalModel.dart';
import 'package:untitled/Model/AvisoModel.dart';
import 'package:untitled/Model/EspecieModel.dart';
import 'package:untitled/Model/PorteModel.dart';
import 'package:untitled/Model/RacaModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:untitled/View/MeusAnimaisView.dart';

//ignore: must_be_immutable
class RegistroAnimal extends StatefulWidget {

  UsuarioModel user = new UsuarioModel();
  RegistroAnimal(this.user);

  _RegistroAnimalState createState() => _RegistroAnimalState();
}

class _RegistroAnimalState extends State<RegistroAnimal> {


  UsuarioModel usuario = new UsuarioModel();

  @override
  void initState(){
    super.initState();
    usuario = super.widget.user;
    // montaCadastroAnimal();
  }

  final UsuarioController uc = new UsuarioController();
  final AnimalController ac = new AnimalController();
  final EspecieController ec = new EspecieController();
  final RacaController rc = new RacaController();
  final PorteController pc = new PorteController();
  final Aviso aviso = new Aviso();

  List<Porte> portes = [];
  List<Raca> racas = [];
  List<Especie> especies = [];

  late List<Map<String, dynamic>> _especie = [];
  late List<Map<String, dynamic>> _raca = [];
  late List<Map<String, dynamic>> _porte = [];

  late String valueChoose='';
  String? value;

  final _formKey = GlobalKey<FormState>();

  final _idanimal = TextEditingController();
  final _descricao = TextEditingController();
  final _local = TextEditingController();
  final _data = TextEditingController();
  final _nome = TextEditingController();
  final _idade = TextEditingController();
  final _foto = TextEditingController();
  Animal animal = new Animal();
  int _idEspecie = 0;
  int _idRaca = 0;
  int _idPorte = 0;
  late String erro ="";


  @override
  void dispose(){
    _idanimal.dispose();
    _descricao.dispose();
    _local.dispose();
    _data.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Registro de Animais",),
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
        child: FutureBuilder(
          future: montaCadastroAnimal() ,
          builder: (BuildContext context, AsyncSnapshot dados){
            if(_porte.length > 0 && _raca.length >0 && _especie.length>0){
              return SingleChildScrollView(
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
                              SelectFormField(
                                cursorColor: Colors.black87,
                                style: TextStyle(
                                    color: Colors.green
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 1.0)
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  labelText: 'Especie',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.archive_rounded,
                                    color: Colors.black87,
                                  ),
                                ),
                                type: SelectFormFieldType.dialog, // or can be dialog
                                initialValue: '',
                                items: _especie,
                                validator: (val){
                                  if(val == null ){
                                    return "Porte Obrigatorio.";
                                  }
                                  if(_idEspecie == 0 ){
                                    return "Porte Obrigatorio.";
                                  }
                                },
                                onChanged: (val) => _idEspecie = int.parse(val),
                                onSaved: (val) => print(val),
                              ), SizedBox(height: 15,),SelectFormField(
                                cursorColor: Colors.black87,
                                style: TextStyle(
                                    color: Colors.green
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 1.0)
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  labelText: 'Raça',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.archive_rounded,
                                    color: Colors.black87,
                                  ),
                                ),
                                type: SelectFormFieldType.dialog, // or can be dialog
                                initialValue: '',
                                items: _raca,
                                validator: (val){
                                  if(val == null ){
                                    return "Porte Obrigatorio.";
                                  }
                                  if(_idRaca == 0 ){
                                    return "Porte Obrigatorio.";
                                  }
                                },
                                onChanged: (val) => _idRaca = int.parse(val),
                                onSaved: (val) => print(val),
                              ), SizedBox(height: 15,),
                              SelectFormField(
                                cursorColor: Colors.black87,
                                style: TextStyle(
                                    color: Colors.green
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black, width: 1.0)
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  labelText: 'Porte',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.archive_rounded,
                                    color: Colors.black87,
                                  ),
                                ),
                                type: SelectFormFieldType.dialog, // or can be dialog
                                initialValue: '',
                                items: _porte,
                                validator: (val){
                                  if(val == null ){
                                    return "Porte Obrigatorio.";
                                  }
                                  if(_idPorte == 0 ){
                                    return "Porte Obrigatorio.";
                                  }
                                },
                                onChanged: (val) => _idPorte = int.parse(val),
                                onSaved: (val) => print(val),
                              ), SizedBox(height: 15,),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  new LengthLimitingTextInputFormatter(2),
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
                                  labelText: 'Idade',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.black87,
                                  ),
                                ),
                                controller: _idade,
                                validator: (String? value){
                                  if(value == null || value.isEmpty){
                                    return "Idade obrigatório";
                                  }
                                },
                              ),SizedBox(height: 15,),
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
                                  labelText: 'Nome',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Colors.black87,
                                  ),
                                ),
                                controller: _nome,
                                validator: (String? value){
                                  if(value == null || value.isEmpty){
                                    return "Nome obrigatório";
                                  }
                                },
                              ), SizedBox(height: 15,),TextFormField(
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
                                  labelText: 'Foto (link)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black87,
                                  ),
                                ),
                                controller: _foto,
                                validator: (String? value){
                                  if(value == null || value.isEmpty){
                                    return "Foto obrigatório";
                                  }
                                },
                              ), SizedBox(height: 15,),
                              ElevatedButton(onPressed: () {
                                var formValid = _formKey.currentState?.validate() ?? false;
                                if(formValid){
                                  animal.idusuario = usuario.idusuario;
                                  animal.idespecie = _idEspecie;
                                  animal.idraca = _idRaca;
                                  animal.idporte = _idPorte;
                                  animal.nome = _nome.text;
                                  animal.idade = int.parse(_idade.text);
                                  animal.status = true;
                                  animal.fotoanimal = _foto.text;
                                  ac.insertAnimal(animal).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Animal cadastrado com sucesso."),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 4),
                                    ));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAnimais(usuario) ));
                                  });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Confira os dados informados."),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 4),
                                  ));
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
                        'Carregando',
                        style: TextStyle(
                            color: Colors.teal
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        }
      ),
    ),
    );
  }

  Future montaCadastroAnimal() async{
    await ec.getAllEspecies().then((value) {
      montaSelectEspecie(value);
    });
    await rc.getAllRacas().then((value) {
      montaSelectRaca(value);
    });
    await pc.getAllPortes().then((value) {
      montaSelectPorte(value);
    });
  }

  montaSelectRaca(List<Raca> lista) {

    for (int i = 0; i < lista.length; i++) {
      _raca.add({
        'value': lista[i].idraca,
        'label': '${lista[i].descricao}'.toUpperCase(),
        'icon': Icon(Icons.done),
      });
    }

  }

    montaSelectEspecie(List<Especie> lista) {
      for (int i = 0; i < lista.length; i++) {
        _especie.add(
        {
          'value': lista[i].idespecie,
          'label': '${lista[i].descricao}'.toUpperCase(),
          'icon': Icon(Icons.done),
        });
      }
    }

    montaSelectPorte(List<Porte> lista) {

      for (int i = 0; i < lista.length; i++) {
        _porte.add(
        {
          'value': lista[i].idporte,
          'label': '${lista[i].descricao}'.toUpperCase(),
          'icon': Icon(Icons.done),
        });
      }
    }

  }
