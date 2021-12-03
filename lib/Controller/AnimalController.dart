import 'package:untitled/Model/AnimalModel.dart';
import 'package:untitled/Model/ConexaoModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';

class AnimalController {

  Future insertAnimal(Animal animal) async {

    var connection = ConexaoModel.getConexao();

    await connection.open();

    var resultsMap = await connection.mappedResultsQuery("insert into public.animal "
        "(idusuario, idespecie, idraca, idporte, nome, idade, fotoanimal, status) "
        "values "
        "('${animal.idusuario}', '${animal.idespecie}','${animal.idraca}', '${animal.idporte}', "
        "'${animal.nome}', '${animal.idade}', '${animal.fotoanimal}', '${animal.status}')");

    await connection.close();

    return resultsMap;
  }

  Future getAnimaisByIdUsuario(UsuarioModel user) async {

    final  List<Animal> lista = [];

    var connection = ConexaoModel.getConexao();

    await connection.open();

    var results = await connection.query(
        "SELECT * FROM animal a where a.idusuario = ${user.idusuario} and a.status = true order by a.idanimal"
    );

    for(var row in results){
      Animal animal = new Animal();
      animal.idanimal = row[0];
      animal.idusuario = row[1];
      animal.idespecie = row[2];
      animal.idraca = row[3];
      animal.idporte = row[4];
      animal.nome = row[5];
      animal.idade = row[6];
      animal.fotoanimal = row[7];
      lista.add(animal);
    }

    await connection.close();

    return lista;
  }


  Future editarStatusAnimal (Animal animal) async{

    final  List<Animal> lista = [];

    var connection = ConexaoModel.getConexao();
    await connection.open();

    await connection.query("UPDATE animal SET status = false WHERE idanimal = ${animal.idanimal}");
    await connection.query("UPDATE aviso SET status = false WHERE idanimal = ${animal.idanimal}");

    connection.close();

    return lista;
  }

// Future EditarStatusAviso (Animal animal) async{
//
//   final  List<AvisoListagem> lista = [];
//
//   var connection = PostgreSQLConnection(
//       "postgresql-44962-0.cloudclusters.net", 18658, "tfc2",
//       username: "leonardo", password: "@Pass#*A");
//
//   await connection.open();
//   print("UPDATE aviso SET status = false WHERE idaviso = ${aviso.idaviso}");
//
//   await connection.query("UPDATE aviso SET status = false WHERE idaviso = ${aviso.idaviso}");
//
//   connection.close();
//
//   return await lista;
// }


}