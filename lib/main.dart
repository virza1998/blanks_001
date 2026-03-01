import 'package:syncfusion_flutter_pdfviewer/syncfusion_flutter_pdfviewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const WorkApp());

class WorkApp extends StatelessWidget {
  const WorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(primary: Colors.amber),
      ),
      themeMode: ThemeMode.dark,
      home: const SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});
  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? selectedType;     // Ввод / Вывод
  String? selectedCategory; // ВВ оборудование / РЗА
  String? selectedItem;     // Конкретный аппарат

  final List<String> types = ['Ввод', 'Вывод'];
  final List<String> categories = ['ВВ оборудование', 'РЗА'];
  final Map<String, List<String>> itemsMap = {
    'ВВ оборудование': ['В-220 Х', 'В-220 К', 'СВ-220', 'ВЛ-220 Х', 'ВЛ-220 К'],
    'РЗА': ['НВЧЗ ВЛ-220 Х', 'КСЗ ВЛ-220 Х', 'ДФЗ ВЛ-220 К', 'КСЗ ВЛ-220 К', 'АПВ В-220 Х', 'АПВ В-220 К', 'УРОВ-110'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Перечень операций')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('psk1.jpg'), // Проверь, что тут JPG или jpg как на диске!
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Тип операции:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedType,
                  isExpanded: true,
                  hint: const Text("Выберите тип"),
                  items: types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() { selectedType = val; }),
                ),
                
                const SizedBox(height: 20),
                const Text("Категория:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: const Text("Выберите категорию"),
                  items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() { selectedCategory = val; selectedItem = null; }),
                ),

                const SizedBox(height: 20),
                if (selectedCategory != null) ...[
                  const Text("Объект:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: selectedItem,
                    isExpanded: true,
                    hint: const Text("Выберите элемент"),
                    items: itemsMap[selectedCategory!]!.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) {
      setState(() {
        selectedItem = val;
      });

      if (val == 'УРОВ-110') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('УРОВ-110')),
              body: SfPdfViewer.asset('urov110.pdf'),
            ),
          ),
        );
      }
    },
                  ),
                ],

                const SizedBox(height: 40),
                if (selectedItem != null && selectedType != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.greenAccent, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text("ИТОГ:", style: TextStyle(color: Colors.greenAccent.shade100, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("$selectedType — $selectedItem", 
                             textAlign: TextAlign.center,
                             style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
