class CepAbertoEndereco {
  final double altitude;
  final double latitude;
  final double longitude;
  final String cep;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoEndereco.fromMap(Map<String, dynamic> map) :
      cep = map['cep'] as String,
      altitude = map['altitude'] as double,
      latitude = double.tryParse(map['latitude'] as String),
      longitude = double.tryParse(map['longitude'] as String),
      bairro = map['bairro'] as String,
      logradouro = map['logradouro'] as String,
      cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
      estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoEndereco{altitude: $altitude, latitude: $latitude, longitude: $longitude, cep: $cep, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade{
  final int ddd;
  final String ibge;
  final String nome;

  Cidade.fromMap(Map<String, dynamic> map) :
        ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;

  @override
  String toString() {
    return '\n - Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }
}

class Estado{
  final String sigla;
  Estado.fromMap(Map<String, dynamic> map) :
    sigla = map['sigla'] as String;

  @override
  String toString() {
    return '\n - Estado{sigla: $sigla}';
  }
}