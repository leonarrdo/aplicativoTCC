import 'package:brasil_fields/brasil_fields.dart';
import 'package:untitled/Controller/AvisosController.dart';
import 'package:untitled/Model/AvisoMapaModel.dart';
import 'package:untitled/Model/AvisoModel.dart';
import 'package:untitled/Model/ConexaoModel.dart';
import 'package:untitled/Model/CoordenadaModel.dart';


class CoordenadaController {
  final AvisosController avisosController = new AvisosController();

  Future insert(Coordenada coord) async {

    late var idCoordenada;

    var connection = ConexaoModel.getConexao();

    await connection.open();

    await connection.query(
        "INSERT INTO COORDENADA (latitude, longitude) values ('${coord.latitute}','${coord.longitude}')"
    );

    idCoordenada = await connection.query(
        "SELECT currval(pg_get_serial_sequence('public.coordenada','idcoordenada'))"
    );

    await connection.close();

    return int.parse(UtilBrasilFields.removeCaracteres(idCoordenada.toString()));

  }

  Future getAllCoordenadas() async {

    final  List<Coordenada> lista = [];

    var connection = ConexaoModel.getConexao();

    await connection.open();

    var results = await connection.query(
        "select c.* from public.coordenada c "
            "join public.aviso a on c.idcoordenada = a.idcoordenada "
            "where a.status = true"
    );

    for(var row in results){
      Coordenada coord = new Coordenada();
      coord.idcoordenada = row[0];
      coord.latitute = row[1];
      coord.longitude = row[2];
      lista.add(coord);
    }

    await connection.close();

    return lista;
  }

  Future getAllCoordenadasPorAviso() async {

    final  List<AvisoMapa> lista = [];

    var connection = ConexaoModel.getConexao();

    await connection.open();

    var results = await connection.query(
        "select a.estado, an.nome, an.fotoanimal, c.*, e.telefone, e.logradouro, a.data from aviso a "
            "join coordenada c on a.idcoordenada = c.idcoordenada "
            "join animal an on a.idanimal = an.idanimal "
            "join usuario u on an.idusuario = u.idusuario "
            "join endereco e on e.idendereco = u.idendereco "
            "where a.status = true;"
    );

    for(var row in results){
      AvisoMapa avisoMapa = new AvisoMapa();

      avisoMapa.estado = row[0];
      avisoMapa.nome = row[1];
      avisoMapa.fotoanimal = row[2];
      avisoMapa.idcoordenada = row[3];
      avisoMapa.latitude = row[4];
      avisoMapa.longitude = row[5];
      avisoMapa.telefone = row[6];
      avisoMapa.logradouro = row[7];
      avisoMapa.data = row[8];

      lista.add(avisoMapa);
    }

    await connection.close();

    return lista;
  }


  Future inserir (Coordenada coordenada, Aviso aviso) async{
    insert(coordenada).then((value) => {
      aviso.idcoordenada = int.parse(UtilBrasilFields.removeCaracteres(value.toString())),
      avisosController.insert(aviso)
    });
  }

}