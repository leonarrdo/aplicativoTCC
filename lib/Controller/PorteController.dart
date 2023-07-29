
import 'package:untitled/databaseConnection.dart' as dataBaseConnection;

import 'package:postgres/postgres.dart';

import 'package:untitled/Model/PorteModel.dart';


class PorteController {

  Future getAllPortes() async {

    final  List<Porte> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results = await connection.query(
        "SELECT * FROM PORTE"
    );

    for(var row in results){
      Porte porte = new Porte();
      porte.idporte = row[0];
      porte.descricao = row[1];
      lista.add(porte);
    }

    await connection.close();

    return lista;
  }

}