import 'package:http/http.dart' as http;
import 'package:untitled/model/ResultCEP.dart';

class ViaCepService {
  static Future<ResultCEP> fetchCep(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      return ResultCEP.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}