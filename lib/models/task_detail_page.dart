import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_task_page.dart';
import '../services/database_service.dart';

void main() => runApp(const TaskDetailPage());

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({Key? key}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  DatabaseService dbService = DatabaseService();
  List<Map<String, dynamic>> _tasks = [];
  int? _selectedRowIndex;

  @override
  void initState() {
    super.initState();
    dbService.initDatabase();
    loadTasks();
  }

  Future<void> loadTasks() async {
    var loadedTasks = await dbService.getTasks();
    setState(() {
      _tasks = loadedTasks;
    });
  }

  void _deleteTask(Map<String, dynamic> task) async {
    try {
      await dbService.deleteTask(task['id']);
      await loadTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görev silindi'),
        ),
      );
    } catch (e) {
      print('Görev silme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görev silinirken bir hata oluştu'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Detay Listesi'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20.0,
            columns: [
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Görev Adı',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Detay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Önem Derecesi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Başlangıç Tarihi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Atanan Kişi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'İşlemler',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            rows: _tasks.asMap().map((index, task) => MapEntry(index, DataRow(
              selected: index == _selectedRowIndex,
              onSelectChanged: (bool? selected) {
                setState(() {
                  _selectedRowIndex = selected! ? index : null;
                });
              },
              cells: [
                DataCell(Text(task['name'])),
                DataCell(Text(task['detail'])),
                DataCell(Text(task['importance'])),
                DataCell(Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(task['startDate'])))),
                DataCell(Text(task['assignedPerson'])),
                DataCell(
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(task: task),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task),
                      ),
                    ],
                  ),
                ),
              ],
            ))).values.toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadTasks,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
