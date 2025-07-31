class Mes {
  final int idMes;
  final String mesAno;

  Mes({required this.idMes, required this.mesAno});

  factory Mes.fromJson(Map<String, dynamic> json) {
    return Mes(
      idMes: json['idMes'],
      mesAno: json['mesAno'],
    );
  }
}
