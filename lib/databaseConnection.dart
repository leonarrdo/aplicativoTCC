import 'package:postgres/postgres.dart';

const databaseHost      = "localhost";
const databasePort      = 5432;
const databaseName      = "";
const databaseUser      = "";
const databasePassword  = "";

getConnection (){
  return PostgreSQLConnection(databaseHost, databasePort, databaseName, username: databaseUser, password: databasePassword);
}