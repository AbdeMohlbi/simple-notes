import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_notes/note_book.dart';
import 'package:simple_notes/slidable_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.comfortable,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Dialog Title",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: titleController,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "title",
                    icon: Icon(Icons.title_outlined),
                    label: Text("aa")),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "title", icon: Icon(Icons.description_rounded)),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("save"),
              onPressed: () {
                NoteBook().add(
                    note: (titleController.text, descriptionController.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    NoteBook().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent.shade200,
        title: const Text(""),
      ),
      body: ValueListenableBuilder<List<(int, String, String)>>(
        valueListenable: NoteBook(),
        builder: (context, data, child) {
          return data.isEmpty
              ? Center(
                  child: SvgPicture.asset(
                    'assets/note.svg',
                    width: 100,
                  ),
                )
              : ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final contact = data[index];
                    return MyListItem(
                      key: ValueKey(contact),
                      id: contact.$1,
                      title: contact.$2,
                      description: contact.$3,
                      onDelete: (tem) {
                        NoteBook()
                            .remove(index: data[index].$1, record: contact);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent.shade200,
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
