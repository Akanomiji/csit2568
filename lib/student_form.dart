import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentFormPage extends StatefulWidget {
  final String? userid;
  final String? firstname;
  final String? lastname;
  final String? address;
  final String? telno;
  final String? office_name;
  final String? email;
  final int xcase; // 1=Add, 2=Edit

  const StudentFormPage({
    super.key,
    this.userid,
    this.firstname,
    this.lastname,
    this.address,
    this.telno,
    this.office_name,
    this.email,
    required this.xcase,
  });

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  // ⚠️ แก้ไข IP ให้ตรงกับเครื่องของคุณ
  final String apiUrl = "http://127.0.0.1/api/savedatastudent.php";

  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstController;
  late TextEditingController lastController;
  late TextEditingController addressController;
  late TextEditingController telController;
  late TextEditingController officeController;
  late TextEditingController emailController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    firstController = TextEditingController(text: widget.firstname ?? '');
    lastController = TextEditingController(text: widget.lastname ?? '');
    addressController = TextEditingController(text: widget.address ?? '');
    telController = TextEditingController(text: widget.telno ?? '');
    officeController = TextEditingController(text: widget.office_name ?? '');
    emailController = TextEditingController(text: widget.email ?? '');
    passController = TextEditingController();
  }

  Future<void> saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'xcase': widget.xcase.toString(),
        'userid': widget.userid ?? '',
        'firstname': firstController.text,
        'lastname': lastController.text,
        'address': addressController.text,
        'telno': telController.text,
        'office_name': officeController.text,
        'email': emailController.text,
        'password': passController.text, // จะใช้เฉพาะตอนเพิ่มใหม่
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          if (data['status'] == 'success') {
            Navigator.pop(context, true); // ส่งค่า true กลับไปบอกว่ามีการเปลี่ยนแปลง
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['message'] ?? 'เกิดข้อผิดพลาด')));
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.xcase == 1 ? "เพิ่มข้อมูลนักศึกษา" : "แก้ไขข้อมูลนักศึกษา"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstController,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastController,
                decoration: const InputDecoration(labelText: 'นามสกุล'),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกนามสกุล' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'ที่อยู่'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: telController,
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: officeController,
                decoration: const InputDecoration(labelText: 'ชื่อหน่วยงาน (ถ้ามี)'),
              ),
              // เฉพาะตอนเพิ่มใหม่ ให้กรอก Email และ Password
              if (widget.xcase == 1) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'อีเมล'),
                  validator: (v) => v!.isEmpty ? 'กรุณากรอกอีเมล' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passController,
                  decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('บันทึก', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}