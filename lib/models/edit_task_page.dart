import 'package:flutter/material.dart';
import '../services/database_service.dart';

class EditTaskPage extends StatefulWidget {
  @override
  _EditTaskPageState createState() => _EditTaskPageState();

  final Map<String, dynamic> task;
  const EditTaskPage({Key? key, required this.task}) : super(key: key);

}

class _EditTaskPageState extends State<EditTaskPage> {

  late TextEditingController _nameController;
  late TextEditingController _detailController;
  late TextEditingController _importanceController;
  late TextEditingController _assignedPersonController;
  late DateTime _selectedDate;

  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    dbService.initDatabase();
    _nameController = TextEditingController(text: widget.task['name']);
    _detailController = TextEditingController(text: widget.task['detail']);
    _importanceController = TextEditingController(text: widget.task['importance']);
    _assignedPersonController = TextEditingController(text: widget.task['assignedPerson']);
    _selectedDate = DateTime.parse(widget.task['startDate']);
  }


  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    _importanceController.dispose();
    _assignedPersonController.dispose();
    super.dispose();
    _selectedDate;
  }

  void _saveTask() async {
    await dbService.initDatabase(); //
    await dbService.updateTask(
      widget.task['id'],
      _nameController.text,
      _detailController.text,
      _importanceController.text,
      _selectedDate,
      _assignedPersonController.text,
    );
    Navigator.pop(context);
    var showSnackBar = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt güncellendi. Sayfayı yenileyiniz.'),
      ),
    );
  }




  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görevi Düzenle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Görev Adı'),
            ),
            TextField(
              controller: _detailController,
              decoration: InputDecoration(labelText: 'Detay'),
            ),
            TextField(
              controller: _importanceController,
              decoration: InputDecoration(labelText: 'Önem Derecesi'),
            ),
            TextField(
              controller: _assignedPersonController,
              decoration: InputDecoration(labelText: 'Atanan Kişi'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text(
                    'Başlangıç Tarihi '
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${_selectedDate.toLocal().toString().split(' ')[0]}',
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

}