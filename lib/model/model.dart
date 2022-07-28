class MarcacaoUsuario {
  final String nome;
  final String descricao;
  final String tipo;
  final String dataVisita;
  final String observacao;

  MarcacaoUsuario({
    required this.nome, 
    required this.descricao, 
    required this.tipo, 
    required this.dataVisita, 
    required this.observacao
    });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'dataVisita': dataVisita,
      'observacao': observacao
    };
    return map;
  }

  MarcacaoUsuario.fromMap(Map map)
      : this(
          nome: map['nome'],
          descricao: map['descricao'],
          tipo: map['tipo'],
          dataVisita: map['dataVisita'],
          observacao: map['observacao']
  );
}
