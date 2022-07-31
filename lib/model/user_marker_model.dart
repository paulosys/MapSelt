class UserMarker {
  final int id;
  final String nome;
  final String descricao;
  final String tipo;
  final String dataVisita;
  final String observacao;
  final double latitude;
  final double longitude;

  UserMarker(
      {
      required this.id,
      required this.nome,
      required this.descricao,
      required this.tipo,
      required this.dataVisita,
      required this.observacao,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'dataVisita': dataVisita,
      'observacao': observacao,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  UserMarker.fromMap(Map map)
      : this(
            id: map['id'],
            nome: map['nome'],
            descricao: map['descricao'],
            tipo: map['tipo'],
            dataVisita: map['dataVisita'],
            observacao: map['observacao'],
            latitude: map['latitude'],
            longitude: map['longitude']);
}
