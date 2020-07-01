class Endereco {

  Endereco({this.rua, this.numero, this.complemento, this.bairro, this.CEP,
      this.cidade, this.estado, this.latitude, this.longitude});

  String rua;
  String numero;
  String complemento;
  String bairro;
  String CEP;
  String cidade;
  String estado;

  double latitude;
  double longitude;

  Endereco.fromMap(Map<String, dynamic> map) {
    rua = map['rua'] as String;
    numero = map['numero'] as String;
    complemento = map['complemento'] as String;
    bairro = map['bairro'] as String;
    CEP = map['CEP'] as String;
    cidade = map['cidade'] as String;
    estado = map['estado'] as String;
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;

  }

  Map<String, dynamic> toMap(){
    return {
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'CEP': CEP,
      'cidade': cidade,
      'estado': estado,

      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
