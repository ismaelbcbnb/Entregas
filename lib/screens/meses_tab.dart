import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/mes.dart';
import '../services/mes_service.dart';
import '../widgets/custom_red_button.dart';

class MesesTab extends StatefulWidget {
  const MesesTab({Key? key}) : super(key: key);

  @override
  State<MesesTab> createState() => _MesesTabState();
}

class _MesesTabState extends State<MesesTab> {
  List<Mes> _meses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarMeses();
  }

  Future<void> _carregarMeses() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final meses = await ApiService().fetchMeses();
      setState(() {
        _meses = meses;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar meses';
        _loading = false;
      });
    }
  }

  Future<void> _excluirMes(Mes mes) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Confirmar exclusão'),
        content: Text('Deseja excluir o mês ${mes.mesAno}?'),
        actions: [
          TextButton(
            child: Text('Não'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CustomRedButton(
            text: 'Sim',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await http.delete(
        Uri.parse('https://contagemapi.onrender.com/Mes/${mes.idMes}'),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _meses.removeWhere((m) => m.idMes == mes.idMes);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mês ${mes.mesAno} foi excluído com sucesso.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir o mês.')),
        );
      }
    }
  }

  Future<void> _adicionarMes() async {
    final TextEditingController _controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Adicionar mês'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Mês e Ano'),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CustomRedButton(
            text: 'Criar',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (result == true && _controller.text.trim().isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://contagemapi.onrender.com/Mes'),
        headers: {'Content-Type': 'application/json'},
        body: '{"mesAno": "${_controller.text.trim()}"}',
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        await _carregarMeses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mês criado com sucesso.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar o mês.')),
        );
      }
    }
  }

  Future<void> _editarMes(Mes mes) async {
    final TextEditingController _controller = TextEditingController(text: mes.mesAno);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Editar mês'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Mês e Ano'),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CustomRedButton(
            text: 'Editar',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (result == true && _controller.text.trim().isNotEmpty) {
      final response = await http.put(
        Uri.parse('https://contagemapi.onrender.com/Mes/'),
        headers: {'Content-Type': 'application/json'},
        body: '{"idMes": ${mes.idMes}, "mesAno": "${_controller.text.trim()}"}',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        await _carregarMeses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mês editado com sucesso.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar o mês.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _loading
            ? Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : RefreshIndicator(
          onRefresh: _carregarMeses,
          child: _meses.isEmpty
              ? ListView(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Nenhum mês cadastrado'),
                ),
              )
            ],
          )
              : ListView.builder(
            itemCount: _meses.length,
            itemBuilder: (context, index) {
              final mes = _meses[index];
              return Card(
                color: Color(0xFFF5F5F5),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    mes.mesAno,
                    style: TextStyle(
                      color: Color(0xFF646464),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF646464)),
                        onPressed: () => _editarMes(mes),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color(0xFFA6193C)),
                        onPressed: () => _excluirMes(mes),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFA6193C),
            child: Icon(Icons.add, color: Colors.white),
            onPressed: _adicionarMes,
            tooltip: 'Adicionar mês',
          ),
        ),
      ],
    );
  }
}