import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _controlador = TextEditingController();

  void editarTarefa(BuildContext context, int index, List<Tarefa> tarefas) {
    TextEditingController controlador = TextEditingController(text: tarefas[index].descricao);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: controlador,
            decoration: InputDecoration(
              hintText: 'Nova descrição',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controlador.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  setState(() {
                    tarefas[index].descricao = controlador.text;
                  });
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void excluirTarefa(int index, List<Tarefa> tarefas) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_tarefas[index].descricao),
                    value: _tarefas[index].status,
                    onChanged: (novoValor) {
                      setState(() {
                        _tarefas[index].status = novoValor ?? false;
                      });
                    },
                    secondary: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editarTarefa(context, index, _tarefas);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controlador,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(200, 60)),
                    ),
                    child: const Text('Adicionar Tarefa'),
                    onPressed: () {
                      if (_controlador.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        _tarefas.add(
                          Tarefa(
                            descricao: _controlador.text,
                            status: false,
                          ),
                        );
                        _controlador.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
