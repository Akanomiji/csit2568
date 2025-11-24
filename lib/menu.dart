import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_model.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final List<Map<String, dynamic>> menuItems = [
      {"title": "สถานที่ฝึกประสบการณ์", "image": "images/company.png"},
      {"title": "ข้อมูลนักศึกษา", "image": "images/student.png"},
      {"title": "ส่ง Resume", "image": "images/resume.png"},
      {
        "title": "เสนอสถานที่ฝึกประสบการณ์",
        "image": "images/selected_company.png",
      },
      {"title": "บันทึกปฏิบัติงาน", "image": "images/dailywork.png"},
      {"title": "หัวข้อศึกษาพิเศษ", "image": "images/special_project.png"},
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
            tooltip: 'Quit',
            onPressed: () {
              if (Platform.isAndroid || Platform.isIOS) {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            // ปรับจ านวนคอลัมน์ตามขนาดหน้าจอ
            int crossAxisCount = width < 400
                ? 2 // มือถือจอเล็ก
                : width < 700
                ? 3 // มือถือจอใหญ่/แท็บเล็ตเล็ก
                : 4; // หน้าจอใหญ่หรือ web
            // ปรับขนาดฟอนต์อัตโนมัติ
            double fontSize = width < 400
                ? 12
                : width < 700
                ? 14
                : 16;
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical, // แนวตั้ง
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    child: Card(
                      color: const Color.fromARGB(255, 193, 203, 192),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FractionallySizedBox(
                                widthFactor: 0.6, // ก าหนดให้ไอคอนมีขนาดพอดี
                                child: Image.asset(
                                  item['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  item['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        color: const Color.fromARGB(255, 5, 122, 60),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${user.firstname} ${user.lastname}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.office_name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.telno,

                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
