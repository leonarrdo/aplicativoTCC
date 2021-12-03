import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/View/AvisoRegistroView.dart';

//ignore: must_be_immutable
class AvisoMapaMarcacaoView extends StatefulWidget {

  @override
  _AvisoMapaMarcacaoViewState createState() => _AvisoMapaMarcacaoViewState();

  UsuarioModel user = new UsuarioModel();
  AvisoMapaMarcacaoView(this.user);

}

class _AvisoMapaMarcacaoViewState extends State<AvisoMapaMarcacaoView> {

  UsuarioModel usuario = new UsuarioModel();
  String latitude='';
  String longitude='';

  @override
  void initState(){
    super.initState();
    usuario = widget.user;
  }



  static const _initialCameraPosition = CameraPosition(
      target: LatLng(-17.397281, -50.379929),
      zoom: 8,
  );

  late Marker _localizacao = Marker(position: LatLng(-17.397281, -50.379929), markerId: const MarkerId('localizacao'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text("Mapa Avisos",
        ),
        automaticallyImplyLeading: false,
        // leading: PopupMenuButton<int>(
        //   // onSelected: (item) => onSelected(context, item),
        //   icon: Icon(Icons.menu),
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //         value: 0,
        //         child: Text("asdasd")
        //     )
        //   ],
        // ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistroAviso(usuario, latitude: this.latitude, longitude: this.longitude,)));
                  // Navigator.pop(context);
                },
                child: Icon(
                  Icons.save,
                  size: 35,
                ),
              )
          ),
        ],
      ),
      body: Center(
        // child: Padding(
            // padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    myLocationButtonEnabled: false,
                    // myLocationEnabled: true,
                    markers: {
                      _localizacao
                    },
                  onTap: _addMarker,
                ),
                // padding: EdgeInsets.only(bottom: 12),
              ),
            ],
          ),
        ),
      // )
    );
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
