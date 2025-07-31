import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contagem.dart';

class ContagemService {
  static Future<List<Contagem>> fetchContagens() async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Contagem.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar contagens');
    }
  }

  static Future<void> validarOuInvalidar(Contagem contagem, bool entregue) async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem/validar');
    final body = contagem.copyWith(entregue: entregue).toJson();
    await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> entregarOuDevolver(Contagem contagem, bool validado) async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem/entregar');
    final body = contagem.copyWith(validado: validado).toJson();
    await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }
}