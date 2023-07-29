import 'package:brasil_fields/brasil_fields.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/databaseConnection.dart' as dataBaseConnection;
import 'package:untitled/Model/EnderecoModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';

class EnderecoController {
  final UsuarioController uc = new UsuarioController();
  late var idEndereco;

  Future<int> insertEndereco(EnderecoModel endereco) async {
    var connection = dataBaseConnection.getConnection();

    await connection.open();

    await connection.query(
        "insert into public.endereco "
            "(logradouro, telefone, cep, endereco)"
            "values "
            "('${endereco.logradouro}', '${endereco.telefone}', '${endereco
            .cep}', '${endereco.endereco}')"
    );

    idEndereco = await connection.query(
        "SELECT currval(pg_get_serial_sequence('public.endereco','idendereco'))"
    );

    await connection.close();

    return int.parse(UtilBrasilFields.removeCaracteres(idEndereco.toString()));
  }

  Future inserir (EnderecoModel endereco, UsuarioModel user) async{
    insertEndereco(endereco).whenComplete(() => {
      user.idendereco = int.parse(UtilBrasilFields.removeCaracteres(idEndereco.toString())),
      uc.insertUsuario(user)
    });
  }

  Future updateEndereco (EnderecoModel endereco) async{


    var connection = dataBaseConnection.getConnection();

    await connection.open();

    await connection.query("UPDATE endereco  "
        "SET logradouro= '${endereco.logradouro}', "
        "telefone= '${endereco.telefone}', "
        "cep= '${endereco.cep}', "
        "endereco= '${endereco.endereco}' "
        "WHERE idendereco = ${endereco.idEndereco}");

    connection.close();

  }

}