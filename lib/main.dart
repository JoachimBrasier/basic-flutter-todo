import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo', home: Todo());
  }
}

class Todo extends StatefulWidget {
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo> {
  List<String> tasks = <String>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Todo'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(child: TodoForm(onAdd: (String value) {
                  setState(() {
                    tasks = List.from(tasks)..add(value);
                  });
                })),
                Container(
                    child: TaskList(
                        data: tasks,
                        onComplete: (int index) {
                          setState(() {
                            tasks = List.from(tasks)..removeAt(index);
                          });
                        })),
              ],
            ),
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  const TaskList({this.data, this.onComplete});
  final List<String> data;
  final Function onComplete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(data[index])),
                      IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            onComplete(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tache supprimée')));
                          })
                    ],
                  ));
            }));
  }
}

class TodoForm extends StatefulWidget {
  const TodoForm({this.onAdd});
  final Function onAdd;

  @override
  TodoFormState createState() => TodoFormState(onAdd: (String value) {});
}

class TodoFormState extends State<TodoForm> {
  TodoFormState({this.onAdd});
  final Function onAdd;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          child: TextFormField(
            controller: textFieldController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Veuillez compléter le champ';
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: 'Nouvelle tâche',
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.onAdd(textFieldController.text);
                      textFieldController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nouvelle tache ajoutée')));
                    }
                  },
                )),
          ),
        ));
  }
}
