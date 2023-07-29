import 'package:untitled/databaseConnection.dart' as dataBaseConnection;
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/Model/UsuarioPerfilModel.dart';

class UsuarioController {

  Future<List<Map<String, Map<String, dynamic>>>> insertUsuario(UsuarioModel usuario) async {

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var resultsMap = await connection.mappedResultsQuery("insert into public.usuario "
        "(idCategoria, idEndereco, nome, cpf, email, senha, status) "
        "values "
        "('${usuario.idcategoria}', '${usuario.idendereco}','${usuario.nome}', '${usuario.cpf}', "
        "'${usuario.email}', '${usuario.senha}', ${usuario.status})");

    await connection.close();

    return resultsMap;
  }

  Future buscaIdUsuarioCPF(UsuarioModel usuario) async{
    UsuarioModel user = new UsuarioModel();

    var connection = dataBaseConnection.getConnection();

    await connection.open();

    var results = await connection.query("select * from public.usuario u where u.cpf = '${usuario.cpf}' and u.status = true");

    for(var row in results){
      user.idusuario = row[0];
      user.idcategoria = row[1];
      user.idendereco = row[2];
      user.nome = row[3];
      user.cpf = row[4];
      user.email = row[5];
      user.senha = row[6];
      user.fotoPerfil = row[7];
    }

    await connection.close();

    return user;

  }

  Future getUsuarioEndereco (UsuarioModel user) async{

    UsuarioPerfilModel u = new UsuarioPerfilModel();

    var connection = dataBaseConnection.getConnection();

    await connection.open();
    var results =  await connection.query(
        "select u.idusuario,e.idendereco, u.nome, u.email, e.cep, e.telefone, u.senha from usuario u "
            "inner join endereco e on u.idendereco = e.idendereco "
            " where u.idusuario = ${user.idusuario}");

    for(var row in results){
      u.idusuario = row[0];
      u.idendereco = row[1];
      u.nome = row[2];
      u.email = row[3];
      u.cep = row[4];
      u.telefone = row[5];
      u.senha = row[6];
    }

    connection.close();

    return u;
  }

  Future updateUsuario (UsuarioModel user) async{

    UsuarioPerfilModel u = new UsuarioPerfilModel();

    var connection = dataBaseConnection.getConnection();

    await connection.open();
    // print("UPDATE usuario SET nome= '${user.nome}', email= '${user.email}', senha= '${user.senha}' WHERE idusuario = ${user.idusuario}");
    var results =  await connection.query("UPDATE usuario SET nome= '${user.nome}', email= '${user.email}', senha= '${user.senha}' WHERE idusuario = ${user.idusuario}");

    for(var row in results){
      u.idusuario = row[0];
      u.idendereco = row[1];
      u.nome = row[2];
      u.email = row[3];
      u.cep = row[4];
      u.telefone = row[5];
      u.senha = row[6];
    }

    connection.close();

    return u;
  }




}

