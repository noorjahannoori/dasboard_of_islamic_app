
// import 'dart:typed_data';
// import 'package:dasboard/login.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'dart:convert';

// const String API_BASE =
//     "https://islamicapp-nu.vercel.app/api/v1"; // 🔗 Your backend

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   List categories = [];
//   List posts = [];
//   String? selectedCategory;

//   Uint8List? fileBytes;
//   String? fileName;

//   final nameCtrl = TextEditingController();
//   final authorCtrl = TextEditingController();
//   final descCtrl = TextEditingController();

//   // 🔹 Load categories + posts
//   Future<void> loadData() async {
//     final res1 = await http.get(Uri.parse('$API_BASE/category'));
//     final res2 = await http.get(Uri.parse('$API_BASE/islamic-post'));

//     setState(() {
//       categories = jsonDecode(res1.body)['data'];
//       posts = jsonDecode(res2.body)['data'];
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   // 🔹 Pick PDF (Web-safe)
//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         fileBytes = result.files.first.bytes; // ✅ Web-safe
//         fileName = result.files.first.name;
//       });
//     }
//   }

//   // 🔹 Submit new Islamic Post
//   Future<void> submitPost() async {
//     if (fileBytes == null || fileName == null || selectedCategory == null) {
//       print("⚠ Please fill all fields");
//       return;
//     }

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$API_BASE/islamic-post'),
//     );

//     // Form fields
//     request.fields['name'] = nameCtrl.text;
//     request.fields['author'] = authorCtrl.text;
//     request.fields['description'] = descCtrl.text;
//     request.fields['category'] = selectedCategory!;

//     // File (bytes for web)
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'file', // must match backend field name
//         fileBytes!,
//         filename: fileName!,
//         contentType: MediaType('application', 'pdf'),
//       ),
//     );

//     var response = await request.send();
//     final resBody = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       final newPost = jsonDecode(resBody)['newIslamicPost'];
//       setState(() {
//         posts.insert(0, newPost);
//         nameCtrl.clear();
//         authorCtrl.clear();
//         descCtrl.clear();
//         fileBytes = null;
//         fileName = null;
//         selectedCategory = null;
//       });
//       print("✅ Success: $newPost");
//     } else {
//       print("create: $resBody");
//     }
//   }

//   void logout() {
//     // ✅ Yahan token clear karo agar sharedPrefs me save hai
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.indigo, // 🔹 Indigo AppBar
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: logout,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 🔹 Form inside Card
//             Card(
//               elevation: 4,
//               shadowColor: Colors.grey,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: nameCtrl,
//                       decoration: const InputDecoration(labelText: "Name"),
//                     ),
//                     TextField(
//                       controller: authorCtrl,
//                       decoration: const InputDecoration(labelText: "Author"),
//                     ),
//                     TextField(
//                       controller: descCtrl,
//                       decoration: const InputDecoration(
//                         labelText: "Description",
//                       ),
//                     ),
//                     DropdownButtonFormField(
//                       value: selectedCategory,
//                       items: categories.map((cat) {
//                         return DropdownMenuItem(
//                           value: cat['_id'],
//                           child: Text(cat['name']),
//                         );
//                       }).toList(),
//                       onChanged: (val) =>
//                           setState(() => selectedCategory = val as String?),
//                       decoration: const InputDecoration(
//                         labelText: "Select Category",
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: pickFile,
//                       icon: const Icon(Icons.upload_file),
//                       label: Text(
//                         fileName == null ? "Choose PDF" : "PDF: $fileName",
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: submitPost,
//                       icon: const Icon(Icons.add),
//                       label: const Text("Create Post"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 🔹 Posts List
//             const Text(
//               "All Islamic Posts",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: posts.length,
//               itemBuilder: (context, i) {
//                 final post = posts[i];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   elevation: 2,
//                   child: ListTile(
//                     title: Text(post['name']),
//                     subtitle: Text("Category: ${post['category']['name']}"),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
//                       onPressed: () {
//                         final pdfUrl = post['file'];
//                         print("Open PDF: $pdfUrl");
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PlatformFile? pickedFile; // ✅ Works for web + mobile
  bool isUploading = false;

  // TODO: Replace with your Cloudinary details
  static const CLOUDINARY_CLOUD_NAME = "your_cloud_name";
  static const CLOUDINARY_UPLOAD_PRESET = "your_upload_preset";

  /// Pick PDF
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // 👈 Required for Web
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.single;
    });
  }

  /// Upload file to Cloudinary
  Future<String> uploadToCloudinary(PlatformFile file) async {
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$CLOUDINARY_CLOUD_NAME/raw/upload');

    final request = http.MultipartRequest('POST', uri);

    if (file.bytes != null) {
      // ✅ Web (bytes available)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes!,
        filename: file.name,
      ));
    } else if (file.path != null) {
      // ✅ Mobile/Desktop (path available)
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path!,
        filename: file.name,
      ));
    } else {
      throw Exception("No file data found");
    }

    request.fields['upload_preset'] = CLOUDINARY_UPLOAD_PRESET;

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          'Cloudinary upload failed: ${resp.statusCode} ${resp.body}');
    }

    final jsonBody = jsonDecode(resp.body);
    return jsonBody['secure_url'];
  }

  /// Handle Upload Button
  Future<void> handleUpload() async {
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a PDF first")),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final url = await uploadToCloudinary(pickedFile!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploaded Successfully: $url")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: pickPdf,
              child: const Text("Pick PDF"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    pickedFile == null
                        ? "No file picked"
                        : pickedFile!.name,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUploading ? null : handleUpload,
              child: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload to Cloudinary"),
            ),
          ],
        ),
      ),
    );
  }
}
