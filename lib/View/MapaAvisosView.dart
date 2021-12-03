import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Controller/CoordenadaController.dart';
import 'package:untitled/Model/AvisoMapaModel.dart';
import 'package:url_launcher/url_launcher.dart';


class MapaAvisosView extends StatefulWidget {
  const MapaAvisosView({Key? key}) : super(key: key);

  @override
  _MapaAvisosViewState createState() => _MapaAvisosViewState();
}

class _MapaAvisosViewState extends State<MapaAvisosView> {

  CoordenadaController cc = new CoordenadaController();
  List<Marker> markers = [];
  late Future<String> dados;
  int quantidadeMarcacoes = 0;
  String nomeDoguinho = "";
  String fotoDoguinho = "";
  String cidadeDoguinho = "";
  String celularDoguinho = "";
  DateTime data = DateTime.now();
  int estado = 0;
  bool clicouMarcacao = true;
  List<AvisoMapa> animais = [];
  List<Marker> marcacoes = [];

  final f = new DateFormat('dd/MM/yyyy');

  static const _initialCameraPosition = CameraPosition(
      target: LatLng(-17.397281, -50.379929),
      zoom: 8,

  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Mapa Avisos",
        ),
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
            future: cc.getAllCoordenadasPorAviso().then((value) {
              markers = montaMarcacoesMapa(value);
            }),
            builder: (BuildContext context, AsyncSnapshot dados){
            if(markers.length> 0 && clicouMarcacao){
              return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.60,
                        child: GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                            myLocationButtonEnabled: true,
                            markers: markers.map((e) => e).toSet(),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.teal,
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/2,
                                  child: FittedBox(
                                    child: Image.network("${fotoDoguinho != "" ? fotoDoguinho : animais[0].fotoanimal}"),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                                Expanded(child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/2,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: corAviso(estado!= 0 ? estado : animais[0].estado)
                                          // color: Colors.yellowAccent
                                        ),
                                        child: Center(
                                        child: Text(estadoAviso(estado!= 0 ? estado : animais[0].estado),
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
                                        height: 35,
                                      ),
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "${nomeDoguinho != "" ? nomeDoguinho : animais[0].nome}".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.black12
                                          )
                                      ),
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "${f.format(data)}".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.black12
                                          )
                                      ),
                                      Container(
                                          child: Center(
                                            child: Text(
                                              "${cidadeDoguinho !="" ? cidadeDoguinho : animais[0].logradouro} - GO".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.black12
                                          )
                                      ),
                                      Expanded(child: Container(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            abrirWhatsApp();
                                          },
                                          icon: Icon( Icons.phone,
                                            // color: Colors.green,
                                            // size: 20,
                                          ),
                                          style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.black87),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          )
                                          )
                                          ), label: Center(
                                          child: Text("${UtilBrasilFields.obterTelefone("${celularDoguinho != "" ? celularDoguinho : animais[0].telefone}")}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                        height: 60,
                                      ))
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )
                      )
                    ],
                  );
            }else if (markers.length> 0 && !clicouMarcacao){
              return Expanded(
                child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationButtonEnabled: true,
                markers: markers.map((e) => e).toSet(),
                ),
              );
            } else{
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
                        'Carregando Mapa',
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

          // child: Column(
          //   children: [
          //     Expanded(
          //       child: GoogleMap(
          //         initialCameraPosition: _initialCameraPosition,
          //           myLocationButtonEnabled: true,
          //           markers: markers.map((e) => e).toSet(),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      // )
    );
  }
   montaMarcacoesMapa(List<AvisoMapa> value){

     if(marcacoes.isEmpty){
       for (int i = 0; i < value.length; i++) {
         if((value[i].latitude != null && value[i].latitude != '') && (value[i].longitude != null && value[i].longitude != '')){
           Marker marcacao = Marker(
               markerId: MarkerId('${value[i].idcoordenada}'),
               position: LatLng(double.parse(value[i].latitude ?? ''), double.parse(value[i].longitude ?? '')),
               onTap: () {
                 setState(() {
                   estado = value[i].estado ?? 1;
                   nomeDoguinho = value[i].nome ?? '';
                   celularDoguinho = value[i].telefone ?? '';
                   cidadeDoguinho = value[i].logradouro ?? '';
                   fotoDoguinho = value[i].fotoanimal ?? '';
                   data = (value[i].data) as DateTime;
                 });
               }
           );
           marcacoes.add(marcacao);
         }
         AvisoMapa an = new AvisoMapa();
         an.estado = value[0].estado ?? 1;
         an.nome = value[0].nome ?? '';
         an.telefone = value[0].telefone ?? '';
         an.logradouro = value[0].logradouro ?? '';
         an.fotoanimal = value[0].fotoanimal ?? '';
         an.data = (value[0].data) as DateTime;
         animais.add(an);
       }
     }
      return marcacoes;
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
  abrirWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=+55${celularDoguinho != "" ? celularDoguinho : animais[0].telefone}&text=Olá, tudo bem ?";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
