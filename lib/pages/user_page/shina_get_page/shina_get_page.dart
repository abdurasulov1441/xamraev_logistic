import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'package:xamraev_logistic/services/document_button.dart';
import 'package:xamraev_logistic/services/gradientbutton.dart';
import 'package:xamraev_logistic/services/request_helper.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';

class ShinaGetPage extends StatefulWidget {
  const ShinaGetPage({super.key});

  @override
  State<ShinaGetPage> createState() => _ShinaGetPageState();
}

class _ShinaGetPageState extends State<ShinaGetPage> {
  File? photoFile;
  File? videoFile;

  final picker = ImagePicker();

  final TextEditingController workDoneController = TextEditingController();
  final TextEditingController masterAmountController = TextEditingController();
  final TextEditingController sparePartController = TextEditingController();
  final TextEditingController sparePartAmountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> pickPhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) setState(() => photoFile = File(file.path));
  }

  Future<void> pickVideo() async {
    final XFile? file = await picker.pickVideo(source: ImageSource.camera);
    if (file != null) setState(() => videoFile = File(file.path));
  }

  Future<String?> uploadPhoto(File file) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: dio.DioMediaType('image', 'jpg'),
      ),
    });

    final response = await requestHelper.postWithAuthMultipart(
      "/api/v1/upload/photo",
      formData,
      log: true,
    );

    if (response["success"] == true) {
      return response["data"]["url"];
    }
    return null;
  }

  Future<String?> uploadVideo(File file) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: dio.DioMediaType('video', 'mp4'),
      ),
    });

    final response = await requestHelper.postWithAuthMultipart(
      "/api/v1/upload/video",
      formData,
      log: true,
    );

    if (response["success"] == true) {
      return response["data"]["url"];
    }
    return null;
  }

  Future<void> sendShina() async {
    final userId = cache.getInt("user_id");

    if (workDoneController.text.isEmpty ||
        masterAmountController.text.isEmpty ||
        sparePartController.text.isEmpty ||
        sparePartAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcha maydonlarni to‘ldiring")),
      );
      return;
    }

    // 1️⃣ Photo upload
    String? photoUrl;
    if (photoFile != null) {
      photoUrl = await uploadPhoto(photoFile!);
    }

    // 2️⃣ Video upload
    String? videoUrl;
    if (videoFile != null) {
      videoUrl = await uploadVideo(videoFile!);
    }

    final body = {
      "userId": userId,
      "workDone": workDoneController.text.trim(),
      "masterAmount": int.parse(masterAmountController.text),
      "sparePart": sparePartController.text.trim(),
      "sparePartAmount": int.parse(sparePartAmountController.text),
      "photoUrl": photoUrl,
      "videoUrl": videoUrl,
      "comment": noteController.text.trim(),
    };

    try {
      final res = await requestHelper.postWithAuth(
        "/api/v1/tire-installations",
        body,
        log: true,
      );

      if (res["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Muvaffaqiyatli yuborildi")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik: ${res["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ui,
      appBar: AppBar(
        backgroundColor: AppColors.ui,
        centerTitle: true,
        title: const Text("Shina o‘rnatish ma'lumotlari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: workDoneController,
              hint: "Qilingan ish",
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: masterAmountController,
              hint: "Usta haqqi summasi",
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: sparePartController,
              hint: "Zapchast nomi",
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: sparePartAmountController,
              hint: "Zapchast summasi",
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Foto hisobot',
              fileName: photoFile != null ? photoFile!.path.split('/').last : "",
              onPressed: pickPhoto,
              onDelete: () => setState(() => photoFile = null),
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Video hisobot',
              fileName: videoFile != null ? videoFile!.path.split('/').last : "",
              onPressed: pickVideo,
              onDelete: () => setState(() => videoFile = null),
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: noteController,
              hint: "Izoh...",
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            GradientButton(
              onPressed: sendShina,
              text: "Yuborish",
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grade1.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grade1),
        ),
      ),
    );
  }
}
