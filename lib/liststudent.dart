import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_form.dart'; // Import หน้าฟอร์ม

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({super.key});

  @override
  State<ListStudentPage> createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  // ⚠️ แก้ไข IP ให้ตรงกับเครื่องของคุณ
  final String getUrl = "http://127.0.0.1/api/getdatastudent.php";
  final String saveUrl = "http://127.0.0.1/api/savedatastudent.php";

  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(getUrl));
      if (response.statusCode == 200) {
        setState(() {
          students = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching: $e");
    }
  }

  Future<void> deleteStudent(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบข้อมูลนี้ใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('ลบ', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      try {
        final response = await http.post(Uri.parse(saveUrl), body: {
          'xcase': '3',
          'userid': id,
        });
        if (response.statusCode == 200) {
          fetchStudents(); // โหลดข้อมูลใหม่
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบสำเร็จ')));
        }
      } catch (e) {
        print("Delete Error: $e");
      }
    }
  }

  void navigateToForm({Map<String, dynamic>? data}) async {
    // ถ้า data เป็น null แสดงว่าเป็นการเพิ่ม (xcase=1), ถ้ามีค่าคือแก้ไข (xcase=2)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentFormPage(
          xcase: data == null ? 1 : 2,
          userid: data?['userid'],
          firstname: data?['firstname'],
          lastname: data?['lastname'],
          address: data?['address'],
          telno: data?['telno'],
          office_name: data?['office_name'],
          email: data?['email'],
        ),
      ),
    );

    if (result == true) {
      fetchStudents(); // โหลดข้อมูลใหม่ถ้ามีการบันทึกกลับมา
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลนักศึกษา"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 30),
            onPressed: () => navigateToForm(), // ปุ่มเพิ่ม
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(child: Text("ไม่พบข้อมูล"))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(student['firstname'][0] ?? '?'),
                        ),
                        title: Text("${student['firstname']} ${student['lastname']}"),
                        subtitle: Text(student['email'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => navigateToForm(data: student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteStudent(student['userid']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
