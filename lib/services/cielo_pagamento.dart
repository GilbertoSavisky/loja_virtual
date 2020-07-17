import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/cartao_credito.dart';
import 'package:lojavirtualgigabyte/models/user.dart';

class CieloPagamento {

  final CloudFunctions functions = CloudFunctions.instance;

  Future<String> autorizacao({CartaoCredito cartaoCredito, num preco, String pedidoId, User user}) async {
    try{
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': pedidoId,
      'amount': (preco * 100).toInt(),
      'softDescriptor': 'Loja pecas Íntimas',
      'installments': 1,
      'creditCard': cartaoCredito.toJson(),
      'cpf': user.cpf,
      'paymentType': 'CreditCard',
    };
    final HttpsCallable callable = functions.getHttpsCallable(
        functionName: 'authorizeCreditCard'
    );
    callable.timeout = Duration(seconds: 60);
    final response = await callable.call(dataSale);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if(data['success'] as bool){
      return data['paymentId'] as String;
    }
    else{
      debugPrint(data['error']['message']);
      return Future.error(data['error']['message']);

    }
  } catch(e){
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente');
    }
  }

  Future<void> captura(String payId) async {
    final Map<String, dynamic> capturaData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.getHttpsCallable(functionName: 'capturaCartaoCredito');
    callable.timeout = Duration(seconds: 60);
    final response = await callable.call(capturaData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if(data['success'] as bool){
      debugPrint('Captura realizada com sucesso');
    }
    else{
      debugPrint(data['error']['message']);
      return Future.error(data['error']['message']);

    }
  }

  Future<void> cancelar(String payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.getHttpsCallable(functionName: 'cancelarCartaoCredito');
    callable.timeout = Duration(seconds: 60);
    final response = await callable.call(cancelData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if(data['success'] as bool){
      debugPrint('Cancelamento realizado com sucesso');
    }
    else{
      debugPrint(data['error']['message']);
      return Future.error(data['error']['message']);

    }
  }
}