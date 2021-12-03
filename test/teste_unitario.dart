import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/Controller/AvisosController.dart';
import 'package:untitled/Controller/CoordenadaController.dart';
import 'package:untitled/Controller/EspecieController.dart';
import 'package:untitled/Controller/PorteController.dart';
import 'package:untitled/Controller/RacaController.dart';
import 'package:untitled/Controller/UsuarioController.dart';
import 'package:untitled/Model/CoordenadaModel.dart';
import 'package:untitled/Model/EspecieModel.dart';
import 'package:untitled/Model/PorteModel.dart';
import 'package:untitled/Model/RacaModel.dart';
import 'package:untitled/Model/UsuarioModel.dart';
import 'package:untitled/Model/AvisoListagemModel.dart';

  void main(){
    UsuarioModel usr = new UsuarioModel();
    Coordenada coord = new Coordenada();
    AvisoListagem aviso = new AvisoListagem();
    UsuarioController uc = new UsuarioController();
    AvisosController ac = new AvisosController();
    EspecieController ec = new EspecieController();
    RacaController rc = new RacaController();
    PorteController pc = new PorteController();
    CoordenadaController cc = new CoordenadaController();


    List<Especie> listaEspecie = [];
    List<AvisoListagem> listaAvisosListagem = [];
    List<Raca> listaRaca = [];
    List<Porte> listaPorte = [];
    List<Coordenada> listaCoordenada = [];

    group('Usuário', () {

       test('Teste de validação senha usuário', () async {
        usr.senha = "teste";
        expect(usr.senha, "teste");
      });

       test('Teste de validação email usuário', () async {
         usr.email = "teste@gmail.com";
         expect(usr.email, "teste@gmail.com");
       });

       test('Teste de validação nome usuário', () async {
         usr.nome = "Leonardo";
         expect(usr.nome, "Leonardo");
       });

       test('Teste de validação cpf usuário', () async {
         usr.cpf = "83293550045";
         expect(usr.cpf, "83293550045");
       });

      test('Buscar usuário por cpf', () async {
        usr.cpf = '83293550045';
        usr = await uc.buscaIdUsuarioCPF(usr);
        expect(usr.idusuario, 4);
      });

    });

    group('Especies', (){
      test('Buscar por todas especies', () async{
        listaEspecie = await ec.getAllEspecies();
        expect(listaEspecie.length, 1);
      });
    });

    group('Porte', (){
      test('Buscar todos os portes', () async{
        listaPorte = await pc.getAllPortes();
        expect(listaPorte.length, 1);
      });
    });

    group('Raças', (){
      test('Buscar todas as raças', () async{
        listaRaca = await rc.getAllRacas();
        expect(listaRaca.length, 1);
      });
    });

    group('Avisos', (){
      test('Buscar todos os avisos', () async{
        listaAvisosListagem = await ac.getAllAvisos();
        expect(listaAvisosListagem.length, 4);
      });

      test('Validar alteração status aviso', () async{
        aviso.status = true;
        expect(aviso.status, true);
        aviso.status = false;
        expect(aviso.status, false);
      });

      test('Validar alteração status descrição', () async{
        aviso.descricao = "descricao";
        expect(aviso.descricao, "descricao");
      });

    });

    group('Coordenada', (){
      test('Buscar todas coordenadas', () async{
        listaCoordenada = await cc.getAllCoordenadas();
        expect(listaCoordenada.length, 4);
      });

      test('Validar Latitude coordenada', () async{
        coord.longitude = "9999999";
        expect(coord.longitude, "9999999");
      });

      test('Validar Longitude coordenada', () async{
        coord.latitute = "6321459";
        expect(coord.latitute, "6321459");
      });


    });




  }



