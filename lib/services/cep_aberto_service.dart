import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lojavirtualgigabyte/models/cepaberto_endereco.dart';

const token = "2963849a4858665bdcb7fb937b8df8e6";

class CepAbertoService {

  Future<CepAbertoEndereco> getEnderecoFromCep(String cep) async {
    final cepLimpo = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cepLimpo";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String, dynamic>>(endPoint);
      if(response.data.isEmpty){
        return Future.error('CEP inválido');
      }
      final CepAbertoEndereco endereco = CepAbertoEndereco.fromMap(response.data);
      return endereco;

    } on DioError {
      return Future.error('Erro ao buscar CEP');
    }
  }
}