import 'package:untitled/Model/AvisoModel.dart';
import 'package:untitled/databaseConnection.dart' as dataBaseConnection;
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/Model/AvisoListagemModel.dart';

class AvisosController {

  Future insert(Aviso aviso) async {

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    await connection.mappedResultsQuery("insert into public.aviso "
        "(idcoordenada, idanimal, descricao, data, status, estado) "
        "values "
        "('${aviso.idcoordenada}', '${aviso.idanimal}', '${aviso.descricao}', '${aviso.data}', '${aviso.status}','${aviso.estado}')");

    await connection.close();

  }

  Future getAllAvisos () async{
    final  List<AvisoListagem> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results =  await connection.query(
        " select av.idaviso, av.estado, an.nome, an.fotoanimal, ed.logradouro, av.status, ed.telefone, av.descricao, av.data from aviso av"
            " inner join animal an on av.idanimal = an.idanimal"
            " inner join usuario us on an.idusuario = us.idusuario"
            " inner join endereco ed on us.idendereco = ed.idendereco"
            " where av.status=true");

    for(var row in results){
      AvisoListagem avisoListagem = new AvisoListagem();
      avisoListagem.idaviso = row[0];
      avisoListagem.estado = row[1];
      avisoListagem.nome = row[2];
      avisoListagem.fotoanimal = row[3];
      avisoListagem.logradouro = row[4];
      avisoListagem.status = row[5];
      avisoListagem.telefone = row[6];
      avisoListagem.descricao = row[7];
      avisoListagem.data = row[8];
      lista.add(avisoListagem);
    }

    connection.close();

    return lista;
  }

  Future getAvisosPorUsuario (UsuarioModel user) async{

    final  List<AvisoListagem> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results =  await connection.query(
        " select av.idaviso, av.estado, an.nome, an.fotoanimal, ed.logradouro, av.status, ed.telefone from aviso av"
            " inner join animal an on av.idanimal = an.idanimal"
            " inner join usuario us on an.idusuario = us.idusuario"
            " inner join endereco ed on us.idendereco = ed.idendereco"
            " where av.status=true and an.idusuario = ${user.idusuario}");


    for(var row in results){
      AvisoListagem avisoListagem = new AvisoListagem();
      avisoListagem.idaviso = row[0];
      avisoListagem.estado = row[1];
      avisoListagem.nome = row[2];
      avisoListagem.fotoanimal = row[3];
      avisoListagem.logradouro = row[4];
      avisoListagem.status = row[5];
      avisoListagem.telefone = row[6];
      lista.add(avisoListagem);
    }

    connection.close();

    return lista;
  }

  Future editarEstadoAviso (AvisoListagem aviso) async{

    final  List<AvisoListagem> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    await connection.query("UPDATE aviso SET estado = ${aviso.estado} WHERE idaviso = ${aviso.idaviso}");

    connection.close();

    return lista;
  }
  Future editarStatusAviso (AvisoListagem aviso) async{

    final  List<AvisoListagem> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    await connection.query("UPDATE aviso SET status = false WHERE idaviso = ${aviso.idaviso}");

    connection.close();

    return lista;
  }

  Future getAvisosPorAnimal (int idAnimal) async{

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results =  await connection.query(
        "select * from aviso av where av.status=true and av.idanimal = $idAnimal");

    connection.close();

    if(results.isNotEmpty){
      return true;
    }
    return false;
  }


  Future getAvisosFiltro (String dataInicio, String dataFinal,{int idRaca = 0, int idPorte =0, int idEspecie =0}) async{
    final  List<AvisoListagem> lista = [];

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    String query =
        " select av.idaviso, av.estado, an.nome, an.fotoanimal, ed.logradouro, av.status, ed.telefone, av.descricao, av.data from aviso av"
        " inner join animal an on av.idanimal = an.idanimal"
        " inner join usuario us on an.idusuario = us.idusuario"
        " inner join endereco ed on us.idendereco = ed.idendereco"
        " where av.status=true and av.data >= '$dataInicio' and av.data <= '$dataFinal' ";

    if(idEspecie!=0){
      query = query + " and an.idespecie = $idEspecie";
    }
    if(idRaca!=0){
      query = query + " and an.idraca = $idRaca";
    }
    if(idPorte!=0){
      query = query + " and an.idporte = $idPorte";
    }

    print(query);

    var results =  await connection.query(query);

    for(var row in results){
      AvisoListagem avisoListagem = new AvisoListagem();
      avisoListagem.idaviso = row[0];
      avisoListagem.estado = row[1];
      avisoListagem.nome = row[2];
      avisoListagem.fotoanimal = row[3];
      avisoListagem.logradouro = row[4];
      avisoListagem.status = row[5];
      avisoListagem.telefone = row[6];
      avisoListagem.descricao = row[7];
      avisoListagem.data = row[8];
      lista.add(avisoListagem);
    }

    connection.close();

    return lista;
  }


}