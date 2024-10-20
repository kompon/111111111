import 'package:flutter/material.dart';

import 'product_update_screen.dart';  // ต้องใส่ '' รอบ path ให้ถูกต้อง
import '../services/product_service.dart';

class ProductViewScreen extends StatelessWidget {
  final Map productData;
  const ProductViewScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสินค้า'),  // แก้ไขข้อความภาษาไทยให้ถูกต้อง
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                ProductService().imageUrl + "/" + productData['image'],
              ),
            ),
            SizedBox(height: 10),
            Text(productData['proname'] ?? 'ไม่พบชื่อสินค้า'),  // เพิ่มการตรวจสอบ null
            SizedBox(height: 10),
            Text(productData['price'].toString() + ' บาท'),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductUpdateScreen(
                      productData: productData,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit),  // เพิ่มไอคอนให้ปุ่มแก้ไข
              label: Text('แก้ไขข้อมูล'),  // แก้ไขข้อความภาษาไทยให้ถูกต้อง
            ),
          ],
        ),
      ),
    );
  }
}
