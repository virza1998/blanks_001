import 'package:pdfrx/pdfrx.dart';
import 'package:flutter/material.dart';
import 'app_data.dart'; 

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
  String? selectedType;
  String? selectedCategory;
  String? selectedItem;

  final List<String> types = ['Ввод', 'Вывод'];
  final List<String> categories = ['ВВ оборудование', 'РЗА'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Перечень операций')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('psk1.jpg'),
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
  onChanged: (val) => setState(() { selectedType = val; selectedItem = null; }), // Добавь selectedItem = null; здесь
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
                  const Text("Объект (введите название):", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  Autocomplete<String>(
                    key: ValueKey(selectedCategory), 
                   optionsBuilder: (TextEditingValue textEditingValue) {
  if (textEditingValue.text == '' || selectedType == null) {
    return const Iterable<String>.empty();
  }
// 1. Берем все объекты из категории (РЗА или ВВ)
  return AppData.itemsMap[selectedCategory!]!.where((String option) {
    // 2. Проверяем, содержит ли название текст из поиска
    bool matchesSearch = option.toLowerCase().contains(textEditingValue.text.toLowerCase());
    
    // 3. ПРОВЕРКА: Существует ли ключ для этого типа (Ввод или Вывод) в pdfFiles?
    // Это отсечет "Вывод", если выбран "Ввод", и наоборот.
    String key = "${selectedType}_$option";
    bool fileExists = AppData.pdfFiles.containsKey(key);
    
    return matchesSearch && fileExists;
  });
},
                    onSelected: (String selection) {
                      setState(() { selectedItem = selection; });

                      if (selectedType == null) return;

                      String key = "${selectedType}_$selection";

                      if (AppData.pdfFiles.containsKey(key)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: Text('$selectedType $selection')),
                              body: PdfViewer.asset(AppData.pdfFiles[key]!),
                            ),
                          ),
                        );
                      }
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Начните вводить название...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.search, color: Colors.amber),
                        ),
                      );
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
                        Text("ВЫБРАНО:", style: TextStyle(color: Colors.greenAccent.shade100, fontWeight: FontWeight.bold)),
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
