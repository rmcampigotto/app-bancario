import 'package:flutter/material.dart';
import '../models/transacao_entitie.dart';
import '../service/transacao_service.dart';

class Formulario extends StatefulWidget {
  Formulario({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormularioState();
  }
}

class FormularioState extends State<Formulario> {
  final List<TransacaoEntitie> transacoes = [];
  final TextEditingController _transacaoNameController =
      TextEditingController();
  final TextEditingController _transacaoValueController =
      TextEditingController();
  final TransacaoService _transacaoService = TransacaoService();
  String? _errorMessage;

  void _deletarTransacao(TransacaoEntitie transacao) {
    transacoes.remove(transacao);
    _transacaoService.DeleteTransacao(transacao.id ?? 0);
  }

  Future<void> _carregarTransacao() async {
    List<TransacaoEntitie> novasTransacoes = await _transacaoService.GetAllTransacoes();
    setState(()  {
      transacoes.addAll(novasTransacoes);
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarTransacao();
  }

  void _alterarTransacao(TransacaoEntitie transacao) {
    TextEditingController nomeController =
        TextEditingController(text: transacao.nome);
    TextEditingController valorController =
        TextEditingController(text: transacao.valor.toString());
    String? dialogError;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Editar Transação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: "Nome"),
                ),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(labelText: "Valor"),
                ),
                if (dialogError != null)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      dialogError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  const SizedBox(
                    height: 20,
                  ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Salvar'),
                onPressed: () {
                  String? name = nomeController.text;
                  double? valor = double.tryParse(valorController.text);
                  if (name == null || name == "") {
                    dialogError = "Preencha o campo 'Nome'";
                    return;
                  }
                  if (valor == null) {
                    dialogError = "Preencha o campo 'Valor'";
                    return;
                  }
                  setState(() {
                    transacao.nome = name;
                    transacao.valor = valor;
                  });
                  _transacaoService.UpdateTransacao(transacao, transacao.id!);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void adicionarTransacao() {
    String nome = _transacaoNameController.text;
    double value = double.tryParse(_transacaoValueController.text) ?? 0;
    if (nome == "") {
      setState(() {
        _errorMessage =
            "Nome do responsável pela transação não foi preenchido.";
      });
    } else if (value == null || value <= 0) {
      setState(() {
        _errorMessage =
            "Valor da transação não preenchido ou inválido. O valor deve ser maior que R\$ 0.0";
      });
    }

    TransacaoEntitie novaTransacao =
        TransacaoEntitie(nome: nome, valor: value, id: transacoes.last.id! + 1);
    _transacaoService.CreateTransacao(novaTransacao);
    transacoes.add(novaTransacao);
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextField(
              controller: _transacaoNameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _transacaoValueController,
              decoration: const InputDecoration(labelText: "Valor"),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: adicionarTransacao,
          child: const Text("Adicionar Transação"),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        else
          const SizedBox(
            height: 20,
          ),
        Expanded(
          child: Container(
            width: 600,
            child: ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                TransacaoEntitie transacao = transacoes[index];
                return Card(
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: ListTile(
                        title: Text(transacao.nome!),
                        subtitle: Text("Valor: ${transacao.valor.toString()}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  _deletarTransacao(transacao);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.new_label_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                _alterarTransacao(transacao);
                              },
                            ),
                          ],
                        ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
