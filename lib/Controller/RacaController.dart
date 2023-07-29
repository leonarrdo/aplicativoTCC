
import 'package:untitled/databaseConnection.dart' as dataBaseConnection;

import 'package:postgres/postgres.dart';

import 'package:untitled/Model/RacaModel.dart';

class RacaController {

  Future getAllRacas() async {

    final  List<Raca> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results = await connection.query(
        "SELECT * FROM RACA"
    );

    for(var row in results){
      Raca raca = new Raca();
      raca.idraca = row[0];
      raca.idespecie = row[1];
      raca.descricao = row[2];
      lista.add(raca);
    }

    await connection.close();

    return lista;
  }

}