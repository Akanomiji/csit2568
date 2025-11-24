import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

// --- Import หน้าต่างๆ ที่จะลิงก์ไป ---
import 'user_model.dart';
import 'loginpage.dart';
//import 'listcompany.dart'; // หน้าสถานประกอบการ
import 'liststudent.dart'; // หน้าข้อมูลนักศึกษา (ที่เพิ่งสร้าง)

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    // รายการเมนู
    final List<Map<String, dynamic>> menuItems = [
      {"title": "สถานที่ฝึกประสบการณ์", "image": "images/company.png"}, // Index 0
      {"title": "ข้อมูลนักศึกษา", "image": "images/student.png"},       // Index 1
      {"title": "ส่ง Resume", "image": "images/resume.png"},            // Index 2
      {"title": "เสนอสถานที่ฝึกประสบการณ์", "image": "images/selected_company.png"}, // Index 3
      {"title": "บันทึกปฏิบัติงาน", "image": "images/dailywork.png"},   // Index 4
      {"title": "หัวข้อศึกษาพิเศษ", "image": "images/special_project.png"}, // Index 5
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("เมนูหลัก"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'ออกจากระบบ',
            onPressed: () {
              // ออกจากระบบ กลับไปหน้า Login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              // หรือถ้าต้องการปิดแอปเลยให้ใช้:
              // if (Platform.isAndroid) {
              //   SystemNavigator.pop();
              // } else if (Platform.isIOS) {
              //   exit(0);
              // }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- ส่วนแสดงข้อมูลผู้ใช้ (Header) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "สวัสดี, ${user.firstname} ${user.lastname}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "หน่วยงาน: ${user.office_name}",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  "เบอร์โทร: ${user.telno}",
                  style: const TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          // --- ส่วน Grid Menu ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 คอลัมน์
                childAspectRatio: 1.1, // สัดส่วน กว้าง:สูง
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // --- จัดการการกดปุ่มเมนูตรงนี้ ---
                    // if (index == 0) {
                    //   // ไปหน้า สถานประกอบการ
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => const ListCompanyPage()),
                    //   );
                    // } else 
                    if (index == 1) {
                      // ไปหน้า ข้อมูลนักศึกษา (ที่เราเพิ่งทำ)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListStudentPage()),
                      );
                    } else {
                      // เมนูอื่นๆ ที่ยังไม่ได้ทำ
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("เมนู ${menuItems[index]['title']} กำลังพัฒนา")),
                      );
                    }
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // แสดงรูปภาพไอคอน (ถ้ามีไฟล์รูปจริง)
                        // ถ้ายังไม่มีรูป ให้ใช้ Icon แทนไปก่อนเพื่อป้องกัน Error
                        Image.asset(
                          menuItems[index]['image'],
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          menuItems[index]['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}