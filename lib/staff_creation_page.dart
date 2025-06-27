import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_list_page.dart';

class StaffCreationPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? existingData;

  const StaffCreationPage({super.key, this.docId, this.existingData});

  @override
  State<StaffCreationPage> createState() => _StaffCreationPageState();
}

class _StaffCreationPageState extends State<StaffCreationPage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      nameController.text = widget.existingData!['name'];
      idController.text = widget.existingData!['id'];
      ageController.text = widget.existingData!['age'].toString();
    }
  }

  Future<void> saveData() async {
    final name = nameController.text.trim();
    final id = idController.text.trim();
    final age = int.parse(ageController.text.trim());

    final staffData = {'name': name, 'id': id, 'age': age};

    final collection = FirebaseFirestore.instance.collection('staff');
    if (widget.docId == null) {
      await collection.add(staffData);
    } else {
      await collection.doc(widget.docId).update(staffData);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StaffListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80CFF2), // light blue
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/staff_logo.png', height: 120),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter a name';
                          if (value.trim().length > 10) return 'Name cannot exceed 10 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(labelText: 'Staff ID'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter an ID';
                          if (value.trim().length > 6) return 'ID cannot exceed 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter age';
                          final age = int.tryParse(value.trim());
                          if (age == null) return 'Age must be a number';
                          if (age < 18 || age > 55) return 'Age must be between 18 and 55';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005BBB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffListPage()));
                },
                child: const Text('Staff List', style: TextStyle(fontSize: 16, color: Colors.blue)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
