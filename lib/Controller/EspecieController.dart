import 'package:untitled/Model/ConexaoModel.dart';
import 'package:untitled/Model/EspecieModel.dart';


class EspecieController {

  Future getAllEspecies() async {

    final  List<Especie> lista = [];

    var connection = ConexaoModel.getConexao();

    await connection.open();

    var results = await connection.query(
        "SELECT * FROM ESPECIE"
    );

    for(var row in results){
      Especie especie = new Especie();
      especie.idespecie = row[0];
      especie.descricao = row[1];
      lista.add(especie);
    }

    await connection.close();

    return lista;
  }

}