class Contagem {
  final int idContagem;
  final int numCard;
  final int numContagem;
  final double pontosDeFuncao;
  final String sistema;
  final bool validado;
  final bool entregue;
  final String link;
  final String mes;

  Contagem({
    required this.idContagem,
    required this.numCard,
    required this.numContagem,
    required this.pontosDeFuncao,
    required this.sistema,
    required this.validado,
    required this.entregue,
    required this.link,
    required this.mes,
  });

  factory Contagem.fromJson(Map<String, dynamic> json) {
    return Contagem(
      idContagem: json['idContagem'] ?? 0,
      numCard: json['numCard'] ?? 0,
      numContagem: json['numContagem'] ?? 0,
      pontosDeFuncao: (json['pontosDeFuncao'] is int)
          ? (json['pontosDeFuncao'] as int).toDouble()
          : (json['pontosDeFuncao'] ?? 0.0).toDouble(),
      sistema: json['sistema'] ?? '',
      validado: json['validado'] ?? false,
      entregue: json['entregue'] ?? false,
      link: json['link'] ?? '',
      mes: json['mes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idContagem': idContagem,
      'numCard': numCard,
      'numContagem': numContagem,
      'pontosDeFuncao': pontosDeFuncao,
      'sistema': sistema,
      'validado': validado,
      'entregue': entregue,
      'link': link,
      'mes': mes,
    };
  }

  Contagem copyWith({
    int? idContagem,
    int? numCard,
    int? numContagem,
    double? pontosDeFuncao,
    String? sistema,
    bool? validado,
    bool? entregue,
    String? link,
    String? mes,
  }) {
    return Contagem(
      idContagem: idContagem ?? this.idContagem,
      numCard: numCard ?? this.numCard,
      numContagem: numContagem ?? this.numContagem,
      pontosDeFuncao: pontosDeFuncao ?? this.pontosDeFuncao,
      sistema: sistema ?? this.sistema,
      validado: validado ?? this.validado,
      entregue: entregue ?? this.entregue,
      link: link ?? this.link,
      mes: mes ?? this.mes,
    );
  }
}