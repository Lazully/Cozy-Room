import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCmQM4RGgbmwNQQxAq7uHtgGQfFrRuk7NQ",
            authDomain: "cozy-room-52b00.firebaseapp.com",
            projectId: "cozy-room-52b00",
            storageBucket: "cozy-room-52b00.firebasestorage.app",
            messagingSenderId: "489821187729",
            appId: "1:489821187729:web:6d9c339b1cd5fe204ed930",
            measurementId: "G-BSV7XVRFRK"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, String>> diaryEntries =
      []; // Lista para armazenar entradas do diário

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addDiaryEntry(Map<String, String> entry) {
    setState(() {
      diaryEntries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeScreen(),
          const ProfileScreen(),
          AnimalPhotosScreen(),
          RecordsScreen(
              diaryEntries: diaryEntries), // Passando as entradas do diário
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Registros',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Color.fromARGB(255, 178, 24, 57),
        backgroundColor: Colors.teal,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryFormPage(
                onSave: (entry) {
                  _addDiaryEntry(entry); // Adiciona a entrada do diário à lista
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.tealAccent[700],
        child: const Icon(Icons.add),
        tooltip: 'Escrever mais um capítulo do diário',
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> calmActivities = [
    {'title': 'Respirar fundo e focar na respiração', 'isChecked': false},
    {'title': 'Pensar em alguém ou algo que você gosta', 'isChecked': false},
  ];

  final TextEditingController _newActivityController = TextEditingController();

  void _addActivity(String title) {
    setState(() {
      calmActivities.add({'title': title, 'isChecked': false});
    });
  }

  void _editActivity(int index, String newTitle) {
    setState(() {
      calmActivities[index]['title'] = newTitle;
    });
  }

  void _deleteActivity(int index) {
    setState(() {
      calmActivities.removeAt(index);
    });
  }

  void _toggleCheck(int index) {
    setState(() {
      calmActivities[index]['isChecked'] = !calmActivities[index]['isChecked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Que bom te ver aqui!'),
      ),
      body: Container(
        color: const Color(0xFFFAF6F9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Já se cuidou hoje?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB21839),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: calmActivities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        calmActivities[index]['title'],
                        style: const TextStyle(color: Color(0xFFB21839)),
                      ),
                      leading: Checkbox(
                        value: calmActivities[index]['isChecked'],
                        onChanged: (_) => _toggleCheck(index),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              _showEditActivityDialog(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteActivity(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: _newActivityController,
                decoration: const InputDecoration(
                  labelText: 'Nova atividade',
                ),
                onSubmitted: (value) {
                  _addActivity(value);
                  _newActivityController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditActivityDialog(int index) {
    final TextEditingController _editController =
        TextEditingController(text: calmActivities[index]['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Atividade'),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(labelText: 'Nova descrição'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _editActivity(index, _editController.text);
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  final TextEditingController _nameController =
      TextEditingController(text: 'Lazully_03');
  final TextEditingController _descriptionController =
      TextEditingController(text: 'Gosto de momentos tranquilos!');
  final TextEditingController _favoriteColorController =
      TextEditingController(text: 'Verde');
  final TextEditingController _favoriteAnimalController =
      TextEditingController(text: 'Gatos');

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/1200x/3a/aa/38/3aaa381f9e89e91ee366239b5d0ca243.jpg',
                ),
                backgroundColor: Color.fromARGB(255, 223, 183, 5),
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                'Nome:',
                _nameController,
                isEditing,
                icon: Icons.person,
              ),
              _buildEditableField(
                'Descrição:',
                _descriptionController,
                isEditing,
                icon: Icons.description,
              ),
              _buildEditableField(
                'Cor Favorita:',
                _favoriteColorController,
                isEditing,
                icon: Icons.color_lens,
              ),
              _buildEditableField(
                'Animal Favorito:',
                _favoriteAnimalController,
                isEditing,
                icon: Icons.pets,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool isEditing, {
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                      labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                : Text(
                    controller.text,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}

class AnimalPhotosScreen extends StatelessWidget {
  AnimalPhotosScreen({super.key});

  final List<String> motivationalMessages = [
    "Você é incrível, não se esqueça disso!",
    "Cada passo conta, continue avançando!",
    "Acredite em você e tudo será possível.",
    "Dias difíceis não duram para sempre. Continue firme!",
    "Seja gentil consigo mesmo. Você merece cuidado.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases Motivacionais'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: motivationalMessages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            color: Colors.teal[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                motivationalMessages[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecordsScreen extends StatelessWidget {
  final List<Map<String, String>> diaryEntries;

  const RecordsScreen({super.key, required this.diaryEntries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros Anteriores'),
        backgroundColor: Colors.teal,
      ),
      body: diaryEntries.isEmpty
          ? const Center(child: Text('Nenhuma entrada no diário.'))
          : ListView.builder(
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final entry = diaryEntries[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data: ${entry['date']}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Dia da Semana: ${entry['dayOfWeek']}'),
                        Text('Descrição: ${entry['description']}'),
                        Text('Humor: ${entry['mood']}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () {
                                _showEditDiaryDialog(context, index, entry);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                diaryEntries.removeAt(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDiaryDialog(
    BuildContext context,
    int index,
    Map<String, String> entry,
  ) {
    final TextEditingController _descriptionController =
        TextEditingController(text: entry['description']);
    final TextEditingController _moodController =
        TextEditingController(text: entry['mood']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Registro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _moodController,
                decoration: const InputDecoration(labelText: 'Humor'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                entry['description'] = _descriptionController.text;
                entry['mood'] = _moodController.text;
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

class DiaryFormPage extends StatefulWidget {
  final Function(Map<String, String>) onSave; // Callback para salvar a entrada

  const DiaryFormPage({super.key, required this.onSave});

  @override
  State<DiaryFormPage> createState() => _DiaryFormPageState();
}

class _DiaryFormPageState extends State<DiaryFormPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dayOfWeekController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();

  void _saveEntry() {
    final entry = {
      'date': _dateController.text,
      'dayOfWeek': _dayOfWeekController.text,
      'description': _descriptionController.text,
      'mood': _moodController.text,
    };

    widget.onSave(entry); // Chamando o callback para salvar a entrada
    Navigator.pop(context); // Volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data',
                hintText: 'Selecione a data',
              ),
            ),
            TextField(
              controller: _dayOfWeekController,
              decoration: const InputDecoration(
                labelText: 'Dia da Semana',
                hintText: 'Qual é o dia?',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Dia',
                hintText: 'Como foi o seu dia?',
              ),
            ),
            TextField(
              controller: _moodController,
              decoration: const InputDecoration(
                labelText: 'Humor',
                hintText: 'Como está se sentindo?',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
