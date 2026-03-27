import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/storage/secure_storage.dart';

class UploadMusicPage extends StatefulWidget {
  const UploadMusicPage({super.key});

  @override
  State<UploadMusicPage> createState() => _UploadMusicPageState();
}

class _UploadMusicPageState extends State<UploadMusicPage> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();

  PlatformFile? selectedFile;
  bool isLoading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> uploadSong() async {
  // VALIDATE FILE
  if (selectedFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pilih file terlebih dahulu")),
    );
    return;
  }

  // VALIDATE EXTENSION (.mp3)
  final fileName = selectedFile!.name.toLowerCase();
  if (!fileName.endsWith(".mp3")) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hanya file .mp3 yang diperbolehkan")),
    );
    return;
  }

  // VALIDATE INPUT TEXT
  if (titleController.text.isEmpty || artistController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Title dan Artist wajib diisi")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final token = await SecureStorage.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    final dio = Dio();

    final formData = FormData.fromMap({
      "title": titleController.text.trim(),
      "artist": artistController.text.trim(),
      "duration": "00:00:00",
      "file": await MultipartFile.fromFile(
        selectedFile!.path!,
        filename: selectedFile!.name,
      ),
    });

    final response = await dio.post(
      "http://10.0.2.2:8080/api/songs",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload berhasil")),
      );

      Navigator.pop(context);
    }

  } catch (e) {
    print("UPLOAD ERROR: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload gagal")),
    );
  }

  setState(() => isLoading = false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Song")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: "Artist"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Pilih File MP3"),
            ),

            if (selectedFile != null)
              Text("File: ${selectedFile!.name}"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : uploadSong,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}