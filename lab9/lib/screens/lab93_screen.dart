import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final StorageService storage = StorageService();
  List items = [];
  List filtered = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await storage.readData();
    filterItems(searchController.text);
  }

  void autoSave() async {
    await storage.writeData(items);
  }

  void filterItems(String keyword) {
    setState(() {
      filtered = items
          .where((e) => e['name'].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void showItemDialog({Map? item, int? indexInFiltered}) {
    final TextEditingController nameController =
        TextEditingController(text: item != null ? item['name'] : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? "Add Item" : "Edit Item"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter name"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              setState(() {
                if (item == null) {
                  items.add({
                    "id": DateTime.now().millisecondsSinceEpoch,
                    "name": nameController.text
                  });
                } else {
                  int realIndex = items.indexWhere((e) => e['id'] == item['id']);
                  if (realIndex != -1) {
                    items[realIndex]['name'] = nameController.text;
                  }
                }
                autoSave();
                filterItems(searchController.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void confirmDelete(int indexInFiltered) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                var itemToDelete = filtered[indexInFiltered];
                items.removeWhere((e) => e['id'] == itemToDelete['id']);
                autoSave();
                filterItems(searchController.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 9.3 - CRUD JSON")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showItemDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterItems,
              decoration: const InputDecoration(
                hintText: "Search by name...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(filtered[i]['name']),
                  subtitle: Text("ID: ${filtered[i]['id']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showItemDialog(item: filtered[i], indexInFiltered: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDelete(i),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
