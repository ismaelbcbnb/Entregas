import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contagem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_red_button.dart';

class ContagemCard extends StatelessWidget {
  final Contagem contagem;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;
  final VoidCallback onAtualizar;

  const ContagemCard({
    Key? key,
    required this.contagem,
    required this.onEditar,
    required this.onExcluir,
    required this.onAtualizar,
  }) : super(key: key);

  Future<List<String>> _fetchMeses() async {
    final response = await http.get(
      Uri.parse('https://contagemapi.onrender.com/Mes'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<String>((e) => e['mesAno'] as String).toList();
    } else {
      throw Exception('Erro ao carregar meses');
    }
  }

  Future<void> _atualizarContagem(
    BuildContext context, {
    required int idContagem,
    required String numCard,
    required String numContagem,
    required String pontosDeFuncao,
    required String sistema,
    required bool validado,
    required bool entregue,
    required String link,
    required String mes,
  }) async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem');
    final body = jsonEncode({
      "idContagem": idContagem,
      "numCard": numCard,
      "numContagem": numContagem,
      "pontosDeFuncao": pontosDeFuncao,
      "sistema": sistema,
      "validado": validado,
      "entregue": entregue,
      "link": link,
      "mes": mes,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contagem atualizada com sucesso')),
      );
      onAtualizar();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar contagem')));
    }
  }

  void _mostrarModalEdicao(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final numCardController = TextEditingController(
      text: contagem.numCard.toString(),
    );
    final numContagemController = TextEditingController(
      text: contagem.numContagem.toString(),
    );
    final pontosDeFuncaoController = TextEditingController(
      text: contagem.pontosDeFuncao.toString(),
    );
    final linkController = TextEditingController(text: contagem.link);
    String sistema = contagem.sistema == 'S033' ? 'S033' : 'S627';
    String? mesSelecionado = contagem.mes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<String>>(
              future: _fetchMeses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar meses'));
                }
                final meses = snapshot.data ?? [];
                if (mesSelecionado == null && meses.isNotEmpty) {
                  mesSelecionado = meses.first;
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Atualizar Contagem',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: numCardController,
                        decoration: InputDecoration(
                          labelText: 'Número do Card',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe o Card'
                            : null,
                      ),
                      TextFormField(
                        controller: numContagemController,
                        decoration: InputDecoration(
                          labelText: 'Número da Entrega',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe a contagem'
                            : null,
                      ),
                      TextFormField(
                        controller: pontosDeFuncaoController,
                        decoration: InputDecoration(
                          labelText: 'Pontos de Função',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe os pontos de função'
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: sistema,
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(labelText: 'Sistema'),
                        items: ['S627', 'S033']
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) sistema = value;
                        },
                      ),
                      TextFormField(
                        controller: linkController,
                        decoration: InputDecoration(labelText: 'Link'),
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(labelText: 'Mês'),
                        value: mesSelecionado,
                        items: meses
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                        onChanged: (value) {
                          mesSelecionado = value;
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Selecione o mês'
                            : null,
                      ),
                      SizedBox(height: 16),
                      CustomRedButton(
                        text: 'Atualizar',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _atualizarContagem(
                              context,
                              idContagem: contagem.idContagem,
                              numCard: numCardController.text,
                              numContagem: numContagemController.text,
                              pontosDeFuncao: pontosDeFuncaoController.text,
                              sistema: sistema,
                              validado: contagem.validado,
                              entregue: contagem.entregue,
                              link: linkController.text,
                              mes: mesSelecionado ?? '',
                            );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Voltar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _validarContagem(BuildContext context) async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem/validar');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contagem.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Contagem validada com sucesso')));
      onAtualizar();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao validar contagem')));
    }
  }

  Future<void> _entregarContagem(BuildContext context) async {
    final url = Uri.parse('https://contagemapi.onrender.com/Contagem/entregar');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contagem.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Contagem entregue com sucesso')));
      onAtualizar();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao entregar contagem')));
    }
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente excluir a contagem ${contagem.numContagem}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Não'),
            ),
            CustomRedButton(
              text: 'Sim',
              onPressed: () async {
                final url = Uri.parse(
                  'https://contagemapi.onrender.com/Contagem/${contagem.idContagem}',
                );
                final response = await http.delete(url);
                Navigator.of(dialogContext).pop();
                if (response.statusCode == 200 || response.statusCode == 204) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contagem excluída com sucesso')),
                  );
                  onAtualizar();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir contagem')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF5F5F5),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    contagem.entregue ? Icons.class_ : Icons.class_outlined,
                    color: contagem.entregue ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _entregarContagem(context),
                  tooltip: contagem.entregue ? 'Devolver' : 'Entregar',
                ),
                IconButton(
                  icon: Icon(
                    contagem.validado
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: contagem.validado ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _validarContagem(context),
                  tooltip: contagem.validado ? 'Invalidar' : 'Validar',
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card: ${contagem.numCard}',
                    style: TextStyle(
                      color: Color(0xFFA6193C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pontos de função: ${contagem.pontosDeFuncao}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mês: ${contagem.mes}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${contagem.sistema}',
                  style: TextStyle(
                    color: Color(0xFFA6193C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(
                      context,
                    ).style.copyWith(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: contagem.numContagem.toString(),
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchURL(contagem.link),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF646464)),
                      onPressed: () => _mostrarModalEdicao(context),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFFA6193C)),
                      onPressed: () => _confirmarExclusao(context),
                      tooltip: 'Excluir',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
