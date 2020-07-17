import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CartaoCredito {
  String numero;
  String titular;
  String dataValidade;
  String codigoSeguranca;
  String bandeira;

  void setTitular(String nome) => titular = nome;
  void setDataValidade(String data) => dataValidade = data;
  void setCodigoSeguranca(String cvv) => codigoSeguranca = cvv;
  void setNumero(String num) {
    numero = num;
    bandeira = detectCCType(num.replaceAll(' ', '')).toString().toUpperCase().split('.').last;
  }
  Map<String, dynamic> toJson() {
    return {
      'cardNumber': numero.replaceAll(' ', ''),
      'holder': titular,
      'expirationDate': dataValidade,
      'securityCode': codigoSeguranca,
      'brand': bandeira,
    };
  }
  @override
  String toString() {
    return 'CartaoCredito{numero: $numero, titular: $titular, dataValidade: $dataValidade, codigoSeguranca: $codigoSeguranca, bandeira: $bandeira}';
  }
}