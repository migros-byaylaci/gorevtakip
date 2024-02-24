import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../services/database_service.dart';

void main() => runApp(NewTaskPage());

class NewTaskPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewTaskPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailController = TextEditingController();
  final TextEditingController _assignedPersonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedImportance = 'Yüksek';

  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    dbService.initDatabase();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDetailController.dispose();
    _assignedPersonController.dispose();
    super.dispose();
  }

  void _addTaskToDatabase() async {
    await dbService.addTask(
      _taskNameController.text,
      _taskDetailController.text,
      _selectedImportance,
      _selectedDate,
      _assignedPersonController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Eklediğiniz kaydı Anasayfa\'da listeleyebilirsiniz.'),
      ),
    );
  }

  void _presentDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000),
      maxTime: DateTime(2100),
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
        });
            },
    );
  }

  void _showPriorityPicker() {
    Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: ['Düşük', 'Orta', 'Yüksek'],
      ),
      hideHeader: true,
      title: const Text('Öncelik Seç'),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        setState(() {
          _selectedImportance = picker.getSelectedValues()[0];
        });
      },
    ).showDialog(context);
  }

  void _showAddTaskScreen(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Görev adı giriniz.'),
                  controller: _taskNameController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Görevi açıklayınız.'),
                  controller: _taskDetailController,
                ),
                InkWell(
                  onTap: _showPriorityPicker,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Öncelik',
                      hintText: 'Öncelik seçiniz',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_selectedImportance),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _presentDatePicker,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Başlangıç Tarihi',
                      hintText: 'Tarih seçiniz',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${_selectedDate.toLocal().toString().split(' ')[0]}',
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Atanan kişiyi yazınız.'),
                  controller: _assignedPersonController,
                ),
                ElevatedButton(
                  child: const Text('Onay'),
                  onPressed: () {
                    _addTaskToDatabase();
                    Navigator.of(context).pop();
                    _taskNameController.clear();
                    _taskDetailController.clear();
                    _assignedPersonController.clear();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Detay Girişi'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
