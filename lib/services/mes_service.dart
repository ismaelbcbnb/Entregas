import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mes.dart';

class ApiService {
  static const String baseUrl = 'https://contagemapi.onrender.com';

  Future<List<Mes>> fetchMeses() async {
    final response = await http.get(Uri.parse('$baseUrl/Mes'));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData
          .map((item) => Mes.fromJson(item))
          .toList()
        ..sort((a, b) => a.idMes.compareTo(b.idMes));
    } else {
      throw Exception('Erro ao carregar os meses');
    }
  }
}
