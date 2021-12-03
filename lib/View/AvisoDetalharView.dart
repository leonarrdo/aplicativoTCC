import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Model/AvisoListagemModel.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class DetalharAviso extends StatefulWidget {

  AvisoListagem avl = new AvisoListagem();
  DetalharAviso(this.avl);


  @override
  _DetalharAvisoState createState() => _DetalharAvisoState();
}

class _DetalharAvisoState extends State<DetalharAviso> {
  final f = new DateFormat('dd/MM/yyyy');
  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Detalhar Aviso",
        ),
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
        child: Container(
            decoration: BoxDecoration(
              // color: Colors.teal,
            ),
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: corAviso(widget.avl.estado)
                  ),
                  child: Text(
                    estadoAviso(widget.avl.estado).toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.07,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: FittedBox(
                    child: Image.network("${widget.avl.fotoanimal}"),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                    child: Text(
                      "${widget.avl.nome}".toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.only(top: 8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration: BoxDecoration(
                        color: Colors.black87
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Text(
                    "${widget.avl.logradouro} - GO".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Center(
                    child: Text("${f.format(widget.avl.data ?? _dateTime)}".toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Center(
                    child: Text("${widget.avl.descricao}".toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.12,
                ),
                Expanded(
                  child: Container(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          abrirWhatsApp();
                        },
                      icon: Icon( Icons.phone,
                        color: Colors.white,
                        size: 40,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.black87,
                        elevation: 0,
                      ), label: Center(
                        child: Text("${UtilBrasilFields.obterTelefone("${widget.avl.telefone}")}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void onSelected(BuildContext context, int item){
    switch(item){
      case 0:
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

  abrirWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=+55${widget.avl.telefone}&text=Olá, tudo bem ?";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

}
