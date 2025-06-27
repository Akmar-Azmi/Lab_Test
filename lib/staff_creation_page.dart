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
              Image.asset('assets/staff_logo.png', height: 120), // <- Add your image in assets
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
                      buildField("Name", nameController),
                      const SizedBox(height: 12),
                      buildField("ID", idController),
                      const SizedBox(height: 12),
                      buildField("Age", ageController, isNumber: true),
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

  Widget buildField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (label == "Age") {
          final age = int.tryParse(value);
          if (age == null || age < 18 || age > 100) return 'Age must be between 18–100';
        } else if (value.length < 3) {
          return '$label must be at least 3 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
