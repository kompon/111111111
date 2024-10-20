import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import '../services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductUpdateScreen extends StatefulWidget {
  final Map productData;
  const ProductUpdateScreen({super.key, required this.productData});

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _pronameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ProductService _productService = ProductService();

  Future<void> _pickImage(ImageSource source) async {
    // ประกาศตัวแปร pickedFile สำหรับจัดเก็บไฟล์รูปภาพที่เลือก
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // กำหนดให้ตัวแปร _image เก็บข้อมูลไฟล์รูปภาพที่อยู่ในตัวแปร pickedFile
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // กำหนดค่าข้อมูลเริ่มต้นให้กับ TextFields
    _pronameController.text = widget.productData['proname'];
    _priceController.text = widget.productData['price'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลสินค้า'), // แก้ไขข้อความที่มีปัญหา
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // แสดงรูปภาพที่เลือก
              SizedBox(
                height: 150,
                child: _image != null
                    ? Image.file(_image!)
                    : Image.network(
                        ProductService().imageUrl +
                            "/" +
                            widget.productData['image'],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('ถ่ายรูป'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('เลือกรูปจากแกลเลอรี'),
                  ),
                ],
              ),
              TextField(
                controller: _pronameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_image != null) {
                    String proname = _pronameController.text;
                    double price = double.parse(_priceController.text);

                    // เรียกใช้งาน API เพื่อแก้ไขข้อมูล
                    final upload = await _productService.updateProduct(
                        widget.productData['proId'], _image!, proname, price);

                    // ตรวจสอบตัวแปร upload
                    if (upload != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('สำเร็จ'),
                      ));
                      // กลับไปยังหน้าแสดงรายการสินค้า
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ProductListScreen()),
                          (Route<dynamic> route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('ผิดพลาด'),
                      ));
                    }
                  }
                },
                icon: Icon(Icons.save),
                label: Text('แก้ไขข้อมูล'),
              ),
              // เพิ่มโค้ดสำหรับการลบข้อมูล
              ElevatedButton.icon(
                onPressed: () async {
                  // เรียกใช้งาน API เพื่อทำการลบข้อมูล
                  final delete = await _productService.deleteProduct(
                      widget.productData['proId']);
                  
                  if (delete != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('ลบข้อมูลสำเร็จ'),
                    ));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen()),
                        (Route<dynamic> route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('ลบข้อมูลไม่สำเร็จ'),
                    ));
                  }
                },
                icon: Icon(Icons.delete),
                label: Text('ลบข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
