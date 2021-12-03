import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Controller/AnimalController.dart';
import 'package:untitled/Controller/AvisosController.dart';
import 'package:untitled/Controller/CoordenadaController.dart';
import 'package:untitled/Model/AnimalModel.dart';
import 'package:untitled/Model/AvisoModel.dart';
import 'package:untitled/Model/CoordenadaModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:untitled/View/MeusAvisosView.dart';

//ignore: must_be_immutable
class RegistroAviso extends StatefulWidget {

  UsuarioModel user = new UsuarioModel();
  String? latitude;
  String? longitude;

  RegistroAviso(this.user,{this.latitude, this.longitude});

  @override
  _RegistroAvisoState createState() => _RegistroAvisoState();
}

class _RegistroAvisoState extends State<RegistroAviso> {

  UsuarioModel usuario = new UsuarioModel();
  String? latitude='';
  String? longitude='';
  int _idAnimal = 0;
  String _nomeAnimal = "";
  late Future<String> dados;
  bool escolherCoordenada = false;

  @override
  void initState(){
    super.initState();
    usuario = widget.user;
    latitude = widget.latitude;
    longitude = widget.longitude;
  }

  AnimalController ac = new AnimalController();
  AvisosController avcon = new AvisosController();
  CoordenadaController cc = new CoordenadaController();

  late List<Map<String, dynamic>> _animais = [];

  Aviso aviso = new Aviso();
  Animal animal = new Animal();
  Coordenada coord = new Coordenada();
  bool buscaRealizada=false;
  DateTime _dateTime = DateTime.now();
  final f = new DateFormat('dd/MM/yyyy');
  List<Marker> myMarker = [];
  List _nomesAnimais = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''];


  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-17.397281, -50.379929),
    zoom: 8,
  );
  late Marker _localizacao = Marker(position: LatLng(0, 0), markerId: MarkerId('localizacao'));

  final _formKey = GlobalKey<FormState>();

  final _descricao = TextEditingController();

  // final _data = TextEditingController();

  @override
  // void dispose(){
    // _descricao.dispose();
    // _data.dispose();
    // super.dispose();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Registro de Aviso",),
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
          future: ac.getAnimaisByIdUsuario(usuario).then((value) {
            montaSelectAnimal(value);
          }),
          builder: (BuildContext context, AsyncSnapshot dados){
            if(_animais.isNotEmpty && !escolherCoordenada){
              return  SingleChildScrollView(
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
                        // color: Colors.green
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1.0)
                          ),
                            labelStyle: TextStyle(
                            color: Colors.black87
                          ),
                          labelText: _nomeAnimal != "" ? _nomeAnimal : 'Escolha um animal',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.archive_rounded,
                            color: Colors.black87,
                          ),
                        ),
                        type: SelectFormFieldType.dialog, // or can be dialog
                        initialValue: '',
                        items: _animais,
                        onChanged: (val) {
                            _idAnimal = int.parse(val);
                            _nomeAnimal = _nomesAnimais[_idAnimal];
                        },
                        onSaved: (val) => print(val),
                        validator: (val){
                          if(val == null ){
                            return "Animal Obrigatorio.";
                          }
                          if(_idAnimal == 0 ){
                            return "Animal Obrigatorio.";
                          }
                        },
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
                              _dateTime = date ?? DateTime.now();
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black87
                          ),
                          labelText: f.format(_dateTime),

                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.date_range,
                            color: Colors.black87,
                          ),
                        ),
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
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.assignment_sharp,
                          color: Colors.black87,
                        ),
                      ),
                      controller: _descricao,
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return "Descrição Obrigatório.";
                      }

                      },
                        maxLength: 100,
                        maxLines: 3,
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            this.escolherCoordenada = true;
                          });
                        },
                        icon: Icon( Icons.add_location_alt,
                          // color: Colors.green,
                          size: 30,
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            minimumSize: Size(MediaQuery.of(context).size.width, 50)
                        ),
                        label: Text("LOCALIZAÇÃO"),),
                        SizedBox(height: 15,),
                      ElevatedButton(onPressed: () {
                      var formValid = _formKey.currentState?.validate() ?? false;
                      if(formValid){
                       avcon.getAvisosPorAnimal(_idAnimal).then((value) {
                         if(value){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                             content: Text("Já existe um aviso para o animal escolhido."),
                             backgroundColor: Colors.red,
                             duration: Duration(seconds: 4),
                           ));
                         }else{
                           if((latitude != null && latitude!= '') && (longitude != null && longitude != '')){
                             coord.longitude = longitude;
                             coord.latitute = latitude;
                             aviso.status = true;
                             aviso.descricao = _descricao.text;
                             aviso.idanimal = _idAnimal;
                             aviso.estado = 1;
                             aviso.data = _dateTime;
                             cc.inserir(coord, aviso).then((value) {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                 content: Text("Aviso inserido com sucesso."),
                                 backgroundColor: Colors.green,
                                 duration: Duration(seconds: 4),
                               ));
                               Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAvisos(usuario)));
                             });
                           }else{
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                               content: Text("Por favor escolha uma localização."),
                               backgroundColor: Colors.red,
                               duration: Duration(seconds: 4),
                             ));
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => MeusAnimais(usuario) ));
                           }
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
                  ],),);
            }else if(!buscaRealizada && _animais.length <= 0){
              return Column(
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
              );
            }else if(_animais.isNotEmpty && escolherCoordenada){
              return Column(
                children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.77,
                    child: GoogleMap(
                      initialCameraPosition: _initialCameraPosition,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      onTap: _addMarker,
                      markers: {_localizacao},
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.04,
                    color: Colors.teal,
                    child: Center(
                      child: Text("Clique sobre o mapa para criar uma marcação",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              this.escolherCoordenada = false;
                            });
                          },
                          icon: Icon( Icons.save,
                            // color: Colors.green,
                            // size: 20,
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.teal),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  )
                              )
                          ), label: Center(
                          child: Text("Salvar Localização",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ),
                      )
                  )
                ],
              );
          }else{
              return Container(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: Text("É necessário cadastrar um animal antes de criar um aviso.",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              );
            }
          },
          ),
        ),
    );
  }

  montaSelectAnimal(List<Animal> lista) {
    if(_animais.isEmpty){
      for (int i = 0; i < lista.length; i++) {
        _animais.add({
          'value': lista[i].idanimal,
          'label': lista[i].nome,
          'icon': Icon(Icons.done)
        });
        int idAnimal = _animais[i]['value'];
        String nomeAnimal = _animais[i]['label'];
        print("$idAnimal $nomeAnimal");
        _nomesAnimais.insert(idAnimal, nomeAnimal);
      }
    }
    buscaRealizada = true;
  }
  void _addMarker(LatLng pos) {
    setState(() {
      _localizacao = Marker(
        markerId: const MarkerId('localizacao'),
        infoWindow: const InfoWindow(title: 'Localização'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
      this.latitude = pos.latitude.toString();
      this.longitude = pos.longitude.toString();
    });
  }

}
