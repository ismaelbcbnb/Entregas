import 'package:flutter/material.dart';
import '../models/contagem.dart';
import '../services/contagem_service.dart';
import '../widgets/contagem_card.dart';
import '../widgets/custom_red_button.dart';
import '../models/mes.dart';
import '../services/mes_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContagensTab extends StatefulWidget {
  const ContagensTab({Key? key}) : super(key: key);

  @override
  _ContagensTabState createState() => _ContagensTabState();
}

class _ContagensTabState extends State<ContagensTab> {
  late Future<List<Contagem>> _contagensFuture;
  String filtroMes = 'Todos os meses';
  String filtroSistema = 'Todos os sistemas';
  String filtroEntregue = 'Entregues/A entregar';
  String filtroValidado = 'Validadas/A validar';

  @override
  void initState() {
    super.initState();
    _contagensFuture = ContagemService.fetchContagens();
  }

  void _atualizarContagens() {
    setState(() {
      _contagensFuture = ContagemService.fetchContagens();
    });
  }

  List<Contagem> _filtrarContagens(List<Contagem> contagens) {
    return contagens.where((c) {
      final filtroMesOk = filtroMes == 'Todos os meses' || c.mes == filtroMes;
      final filtroSistemaOk =
          filtroSistema == 'Todos os sistemas' || c.sistema == filtroSistema;
      final filtroEntregueOk =
          filtroEntregue == 'Entregues/A entregar' ||
          (filtroEntregue == 'Entregues' && c.entregue) ||
          (filtroEntregue == 'A entregar' && !c.entregue);
      final filtroValidadoOk =
          filtroValidado == 'Validadas/A validar' ||
          (filtroValidado == 'Validadas' && c.validado) ||
          (filtroValidado == 'A validar' && !c.validado);
      return filtroMesOk &&
          filtroSistemaOk &&
          filtroEntregueOk &&
          filtroValidadoOk;
    }).toList();
  }

  void _limparFiltros() {
    setState(() {
      filtroMes = 'Todos os meses';
      filtroSistema = 'Todos os sistemas';
      filtroEntregue = 'Entregues/A entregar';
      filtroValidado = 'Validadas/A validar';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Contagem>>(
        future: _contagensFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Erro ao carregar entregas'));
          final contagens = snapshot.data ?? [];

          final meses = [
            'Todos os meses',
            ...{...contagens.map((c) => c.mes)},
          ];
          final sistemas = [
            'Todos os sistemas',
            ...{...contagens.map((c) => c.sistema)},
          ];
          final contagensFiltradas = _filtrarContagens(contagens);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Color(0xFF646464)),
                        value: filtroMes,
                        isExpanded: true,
                        items: meses
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                        onChanged: (value) => setState(
                          () => filtroMes = value ?? 'Todos os meses',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Color(0xFF646464)),
                        value: filtroSistema,
                        isExpanded: true,
                        items: sistemas
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (value) => setState(
                          () => filtroSistema = value ?? 'Todos os sistemas',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Color(0xFF646464)),
                        value: filtroEntregue,
                        isExpanded: true,
                        items:
                            ['Entregues/A entregar', 'Entregues', 'A entregar']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) => setState(
                          () =>
                              filtroEntregue = value ?? 'Entregues/A entregar',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Color(0xFF646464)),
                        value: filtroValidado,
                        isExpanded: true,
                        items: ['Validadas/A validar', 'Validadas', 'A validar']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) => setState(
                          () => filtroValidado = value ?? 'Validadas/A validar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  left: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Quantidade de entregas: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${contagensFiltradas.length}',
                                    style: TextStyle(
                                      color: Color(0xFFA6193C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA6193C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: _limparFiltros,
                      child: Icon(Icons.filter_alt_off, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Card(
                color: Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'PF: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${contagensFiltradas.fold<double>(0, (sum, c) => sum + c.pontosDeFuncao)}',
                              style: TextStyle(
                                color: Color(0xFFA6193C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Entregues: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${contagensFiltradas.where((c) => c.entregue).fold<double>(0, (sum, c) => sum + c.pontosDeFuncao)}',
                              style: TextStyle(
                                color: Color(0xFFA6193C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Validadas: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${contagensFiltradas.where((c) => c.validado).fold<double>(0, (sum, c) => sum + c.pontosDeFuncao)}',
                              style: TextStyle(
                                color: Color(0xFFA6193C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 72),
                  children: contagensFiltradas
                      .map(
                        (contagem) => ContagemCard(
                          contagem: contagem,
                          onEditar: () {},
                          onExcluir: () {},
                          onAtualizar: _atualizarContagens,
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA6193C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () => _mostrarModalAdicionarContagem(context),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Adicionar Entrega',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarModalAdicionarContagem(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController numCardController = TextEditingController();
    final TextEditingController numContagemController = TextEditingController();
    final TextEditingController pontosDeFuncaoController =
        TextEditingController();
    String sistema = 'S627';
    String? mesSelecionado;

    List<Mes> meses = [];
    try {
      meses = await ApiService().fetchMeses();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar meses')));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Adicionar Entrega',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: numCardController,
                      decoration: InputDecoration(labelText: 'Número do Card'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: numContagemController,
                      decoration: InputDecoration(
                        labelText: 'Número da Entrega',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: pontosDeFuncaoController,
                      decoration: InputDecoration(
                        labelText: 'Pontos de Função',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: sistema,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(labelText: 'Sistema'),
                      items: ['S627', 'S033', 'S079']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => sistema = value ?? 'S627'),
                    ),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(labelText: 'Mês'),
                      value: mesSelecionado,
                      items: meses
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.mesAno,
                              child: Text(m.mesAno),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => mesSelecionado = value),
                    ),
                    SizedBox(height: 16),
                    CustomRedButton(
                      text: 'Adicionar',
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() ||
                            mesSelecionado == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Preencha todos os campos')),
                          );
                          return;
                        }
                        final baseUrl =
                            'https://s2clmg01/ccm/web/projects/%5BPA%5D%20Gest%C3%A3o%20de%20Contratos#action=com.ibm.team.workitem.viewWorkItem&id=';
                        final numEntrega = numContagemController.text.trim();
                        final contagemJson = {
                          "numCard": int.tryParse(numCardController.text) ?? 0,
                          "numContagem":
                              int.tryParse(numContagemController.text) ?? 0,
                          "pontosDeFuncao":
                              double.tryParse(
                                pontosDeFuncaoController.text.replaceAll(
                                  ',',
                                  '.',
                                ),
                              ) ??
                              0.0,
                          "sistema": sistema,
                          "validado": false,
                          "entregue": false,
                          "link": '$baseUrl$numEntrega',
                          "mes": mesSelecionado,
                        };
                        final response = await http.post(
                          Uri.parse(
                            'https://contagemapi.onrender.com/Contagem',
                          ),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(contagemJson),
                        );
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Navigator.of(context).pop();
                          _atualizarContagens();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar contagem'),
                            ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
