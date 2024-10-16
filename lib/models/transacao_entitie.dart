class TransacaoEntitie {
  int? id;
  String? nome;
  double? valor;

  TransacaoEntitie({this.id, this.nome, this.valor});

  factory TransacaoEntitie.fromJson(Map<String, dynamic> json) {
    return TransacaoEntitie(
      id: json['id'],
      nome: json['nome'],
      valor: json['valor'],
    );
  }

}