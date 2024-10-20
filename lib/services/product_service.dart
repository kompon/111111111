import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProductService {
// URL ของ RESTful API
final String baseUrl = 'http://192.168.56.1:3000/api';
// URL ของรูปภาพ
final String imageUrl = 'http://192.168.56.1:3000/images';
//เพิ่มข8อมูลสินค8าใหมK

Future<Map<String, dynamic>?> createProduct(
File imageFile, String proname, double price) async {
var request = http.MultipartRequest(
'POST',
Uri.parse('$baseUrl/products'),
);
request.fields.addAll({
'proname': proname,
'price': price.toString(),
});
request.files.add(
await http.MultipartFile.fromPath('image', imageFile.path),
);
var response = await request.send();

if (response.statusCode == 200) {
String data = await response.stream.bytesToString();
return jsonDecode(data);
} else {
return null;
}
}
//ดึงข8อมูลสินค8าทั้งหมด
Future<List<dynamic>> fetchProducts() async {
final response = await http.get(Uri.parse('$baseUrl/products'));

if (response.statusCode == 200) {
List<dynamic> data = jsonDecode(response.body);
return data;

} else {
throw Exception('ไมKสามารถโหลดข8อมูลสินค8าได8');
}
}

//แก8ไขข8อมูลสินค8า
Future<Map<String, dynamic>?> updateProduct(
int proId, File imageFile, String proname, double price) async {
var request = http.MultipartRequest(
'PUT',
Uri.parse('$baseUrl/products/$proId'),
);
request.fields.addAll({
'proname': proname,
'price': price.toString(),
});
request.files.add(
await http.MultipartFile.fromPath('image', imageFile.path),
);
var response = await request.send();
if (response.statusCode == 200) {
String data = await response.stream.bytesToString();
return jsonDecode(data);
} else {
return null;
}
}

//ลบข8อมูลสินค8าตาม proId
Future<bool> deleteProduct(int proId) async {

final response = await http.delete(Uri.parse('$baseUrl/products/$proId'));
if (response.statusCode == 200) {
return true;
} else {
throw Exception('ไมKสามารถโหลดข8อมูลสินค8าได8');
}
}
}