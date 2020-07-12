import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:lojavirtualgigabyte/helpers/extensions.dart';

enum LojaStatus {FECHADA, ABERTA, FECHANDO}

class Loja {

  Loja.fromDocumento(DocumentSnapshot documento){
    nome = documento.data['nome'] as String;
    imagem = documento.data['imagem'] as String;
    telefone = documento.data['telefone'] as String;
    endereco = Endereco.fromMap(documento.data['endereco'] as Map<String, dynamic>);
    operando = (documento.data['operando'] as Map<String, dynamic>).map((key, value) {
      final timeString = value as String;

      if(timeString != null && timeString.isNotEmpty){
        final separados = timeString.split(RegExp(r'[:-]'));
        return MapEntry(
          key, {
            'from': TimeOfDay(
              hour: int.parse(separados[0]),
              minute: int.parse(separados[1])
            ),
            'to': TimeOfDay(
              hour: int.parse(separados[2]),
              minute: int.parse(separados[3])
            )
        }
        );
      }
      else {
        return MapEntry(key, null);
      }
    });

    updateStatus();
  }

  String nome;
  String imagem;
  String telefone;
  Endereco endereco;
  Map<String, Map<String, TimeOfDay>> operando;
  LojaStatus status;

  String get enderecoTexto => '${endereco.rua}, ${endereco.numero}, ${endereco.complemento.isNotEmpty ? endereco.complemento : ''} - '
      '${endereco.bairro}, ${endereco.cidade}/${endereco.estado}';

  String get operandoTExto => 'Seg-Sex: ${formatarPeriodo(operando['segsex'])}\n'
      'Sab: ${formatarPeriodo(operando['sabado'])}\n'
      'Dom: ${formatarPeriodo(operando['domingo'])}';

  String formatarPeriodo(Map<String, TimeOfDay> periodo){
    if(periodo == null){
      return 'Fechado';
    }
    return '${periodo['from'].formatarTime()} - ${periodo['to'].formatarTime()}';
  }

  void updateStatus() {
    final diaSemana = DateTime
        .now()
        .weekday;

    Map<String, TimeOfDay> periodo;
    if (diaSemana >= 1 && diaSemana <= 5) {
      periodo = operando['segsex'];
    } else if (diaSemana == 6) {
      periodo = operando['sabado'];
    }
    else {
      periodo = operando['domingo'];
    }
    final agora = TimeOfDay.now();
    if(periodo == null){
      status = LojaStatus.FECHADA;
    }
    else if(periodo['from'].toMinutos() < agora.toMinutos() && periodo['to'].toMinutos() -15 > agora.toMinutos()){
      status = LojaStatus.ABERTA;
    }
    else if(periodo['from'].toMinutos() < agora.toMinutos() && periodo['to'].toMinutos() > agora.toMinutos()){
      status = LojaStatus.FECHANDO;
    }
    else {
      status = LojaStatus.FECHADA;
    }
  }

  String get statusTexto{
    switch(status){
      case LojaStatus.FECHADA:
        return 'Fechada';
        break;
      case LojaStatus.ABERTA:
        return 'Aberta';
        break;
      case LojaStatus.FECHANDO:
        return 'Fechando';
        break;
      default:
        return '';
    }
  }
  
  String get telefoneLimpo => telefone.replaceAll(RegExp(r"[^\d]"), '');
}