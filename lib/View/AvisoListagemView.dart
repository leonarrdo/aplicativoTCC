import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:untitled/Controller/AvisosController.dart';
import 'package:untitled/Controller/EspecieController.dart';
import 'package:untitled/Controller/PorteController.dart';
import 'package:untitled/Controller/RacaController.dart';
import 'package:untitled/Model/AvisoListagemModel.dart';
import 'package:untitled/Model/EspecieModel.dart';
import 'package:untitled/Model/PorteModel.dart';
import 'package:untitled/Model/RacaModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/View/AvisoDetalharView.dart';
import 'package:untitled/View/AvisoRegistroView.dart';
import 'package:untitled/View/MapaAvisosView.dart';
import 'package:untitled/View/MeusAnimaisView.dart';
import 'package:untitled/View/MeusAvisosView.dart';
import 'package:untitled/View/UsuarioLoginView.dart';
import 'package:untitled/View/UsuarioPerfilView.dart';

//ignore: must_be_immutable
class AvisosListagem extends StatefulWidget {

  UsuarioModel user = new UsuarioModel();
  AvisosListagem(this.user);

  @override
  _AvisosListagemState createState() => _AvisosListagemState();
}

class _AvisosListagemState extends State<AvisosListagem> {
  UsuarioModel usuario = new UsuarioModel();

  @override
  void initState(){
    super.initState();
    usuario = widget.user;
  }

  int _currendIndex = 0 ;

  AvisosController ac = new AvisosController();
  int idusuario=0;
  List<AvisoListagem> avisos = [];
  late Future<String> dados;
  bool filtrarAvisos = false;
  bool buscaRealizada=false;
  bool filtroApliacado = false;
  final _formKey = GlobalKey<FormState>();
  final _idade = TextEditingController();
  final f = new DateFormat('dd/MM/yyyy');
  final formataBanco = new DateFormat('yyyy/MM/dd');
  late List<Map<String, dynamic>> _especie = [];
  late List<Map<String, dynamic>> _raca = [];
  late List<Map<String, dynamic>> _porte = [];
  final EspecieController ec = new EspecieController();
  final RacaController rc = new RacaController();
  final PorteController pc = new PorteController();
  int _idEspecie = 0;
  int _idRaca = 0;
  int _idPorte = 0;
  int _idadeBusca = 0;
  DateTime _dataAgora = DateTime.now();
  DateTime _dataInicial = DateTime.now();
  DateTime _dataFinal = DateTime.now();
  bool alterarDataInicial = true;
  bool alterarDataFinal = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Listagem Avisos",
        ),
        leading: PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          icon: Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("${widget.user.nome}",)
                  ],
                )
            ),PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.email, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("${widget.user.email}",)
                  ],
                )
            ),PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Meus Avisos",)
                  ],
                )
            ),PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Meus Animais")
                  ],
                )
            ),PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.perm_contact_cal_rounded, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Editar Perfil")
                  ],
                )
            ),PopupMenuItem(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black,),
                    Container(padding: EdgeInsets.only(right: 10, left: 10),),
                    Text("Sair")
                  ],
                )
            ),

          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                      this.filtrarAvisos = true;
                  });
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<AvisoListagem>>(
          future: ac.getAllAvisos().then((value)
          {
            if(_porte.isEmpty || _raca.isEmpty || _especie.isEmpty){
              montaCadastroAnimal();
            }
            if(alterarDataInicial){
              _dataInicial = _dataAgora;
            }
            if(alterarDataFinal){
              _dataFinal = _dataAgora;
            }
            if(avisos.isNotEmpty){
              buscaRealizada = true;
              return avisos;
            }
            if(avisos.isEmpty && filtroApliacado){
              buscaRealizada = true;
              return avisos;
            }
            buscaRealizada = true;
            return avisos = value;
          }), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot dados) {
            if(avisos.length > 0 && !filtrarAvisos) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                itemBuilder: (BuildContext context, index) {
                  return ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetalharAviso(avisos[index])));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(3),
                      primary: Colors.white10,
                      onPrimary: Colors.black,
                      elevation: 0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: corAviso(avisos[index].estado)
                            // color: Colors.yellowAccent
                          ),
                          child: Center(
                            child: Text(estadoAviso(avisos[index].estado),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 3),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 25,
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 115,
                          child: FittedBox(
                            child: Image.network("${avisos[index].fotoanimal}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                            child: Center(
                              child: Text(
                                "${avisos[index].nome}".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.black87
                            )
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: Center(
                            child: Text(
                              "${avisos[index].logradouro} - GO".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
                itemCount: avisos.length,
              );
            }else if(filtrarAvisos){
              return SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 20, 2, 2),
                      child: Form(
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
                            // TextFormField(
                            //   inputFormatters: [
                            //     FilteringTextInputFormatter.digitsOnly,
                            //     new LengthLimitingTextInputFormatter(2),
                            //   ],
                            //   keyboardType: TextInputType.number,
                            //   cursorColor: Colors.black87,
                            //   style: TextStyle(
                            //       color: Colors.black87
                            //   ),
                            //   decoration: InputDecoration(
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: const BorderSide(color: Colors.black, width: 1.0)
                            //     ),
                            //     labelStyle: TextStyle(
                            //         color: Colors.black87
                            //     ),
                            //     labelText: 'Idade animal',
                            //     border: OutlineInputBorder(),
                            //     prefixIcon: const Icon(
                            //       Icons.calendar_today_outlined,
                            //       color: Colors.black87,
                            //     ),
                            //   ),
                            //   controller: _idade,
                            //   onChanged: (val) => _idadeBusca = int.parse(val),
                            //   validator: (String? value){
                            //     if(value == null || value.isEmpty){
                            //       return "Idade obrigatório";
                            //     }
                            //   },
                            // ),SizedBox(height: 15,),
                            TextFormField(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2023)
                                ).then((date) {
                                  setState(() {
                                    _dataInicial = date ?? _dataAgora;
                                    this.alterarDataInicial = false;
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black87
                                ),
                                labelText: _dataInicial != _dataAgora ? f.format(_dataInicial) : "Data Inicial",
                                border: OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.date_range,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2222)
                                ).then((date) {
                                  _dataFinal = date ?? _dataAgora;
                                  this.alterarDataFinal = false;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black87
                                ),
                                labelText: _dataFinal != _dataAgora ? f.format(_dataFinal) : "Data Final",
                                border: OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.date_range,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            ElevatedButton.icon(
                              onPressed: () {
                                String dataInicial = formataBanco.format(_dataInicial)+' 00:00:00';
                                String dataFinal = formataBanco.format(_dataFinal)+' 23:59:59';
                                if(_dataInicial != _dataAgora && _dataFinal != _dataAgora){
                                  ac.getAvisosFiltro(dataInicial, dataFinal, idRaca: _idRaca, idPorte: _idPorte, idEspecie: _idEspecie).then((value) {
                                    setState(() {
                                      this.avisos = value;
                                      this.filtrarAvisos = false;
                                      this.filtroApliacado = true;
                                      this.alterarDataFinal = true;
                                      this.alterarDataInicial = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Busca realizada com sucesso. Para limpar os filtros clique em Home."),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 4),
                                    ));
                                  });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Necessário escolher uma data incial e final."),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 4),
                                  ));
                                }
                              },
                              icon: Icon( Icons.saved_search,
                                // color: Colors.green,
                                size: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal,
                                  onPrimary: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  minimumSize: Size(MediaQuery.of(context).size.width, 50)
                              ),
                              label: Text("FILTRAR"),
                            ),
                            SizedBox(height: 15,),
                            // ElevatedButton.icon(
                            //   onPressed: () {
                            //     setState(() {
                            //         ac.getAllAvisos().then((value) {
                            //           avisos = value;
                            //           this.filtrarAvisos = false;
                            //           this.filtroApliacado = true;
                            //           _idPorte = 0;
                            //           _idRaca = 0;
                            //           _idEspecie = 0;
                            //           _idadeBusca = 0;
                            //           this.alterarDataFinal = true;
                            //           this.alterarDataInicial = true;
                            //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //             content: Text("Filtros removidos."),
                            //             backgroundColor: Colors.green,
                            //             duration: Duration(seconds: 2),
                            //           ));
                            //         });
                            //     });
                            //   },
                            //   icon: Icon( Icons.clear,
                            //     // color: Colors.green,
                            //     size: 30,
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //       primary: Colors.teal,
                            //       onPrimary: Colors.white,
                            //       padding: EdgeInsets.all(8.0),
                            //       minimumSize: Size(MediaQuery.of(context).size.width, 50)
                            //   ),
                            //   label: Text("LIMPAR FILTROS"),
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }else if(!buscaRealizada && avisos.length <= 0){
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
                        'Carregando Avisos',
                        style: TextStyle(
                            color: Colors.teal
                        ),
                      ),
                    )
                  ],
                ),
              );
            }else{
              return Container(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: Text("Nenhum animal encontrado.",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currendIndex,
        iconSize: 40,
        backgroundColor: Colors.teal,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white,),
            label: 'Mapa',
          ),
        ],
        onTap: (index){
          setState(() {
            _currendIndex = index;
            bottomNavigator(_currendIndex);
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
  void onSelected(BuildContext context, int item){
    switch(item){
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAvisos(usuario) ));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAnimais(usuario)));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => UsuarioPerfil(usuario) ));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUsuario() ));
        break;
    }
  }

  bottomNavigator(int index){
    switch(index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AvisosListagem(usuario) ));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MapaAvisosView()));
        break;
    }
  }

   estadoAviso(int? estado){
    if(estado==1){
      return "desaparecido".toUpperCase();
    }
    if(estado==2){
      return "encontrado".toUpperCase();
    }
  }
  corAviso(int? estado){
    if(estado==1){
      return Colors.yellowAccent;
    }
    if(estado==2){
      return Colors.green;
    }
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

