import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'package:xamraev_logistic/services/document_button.dart';
import 'package:xamraev_logistic/services/gradientbutton.dart';
import 'package:xamraev_logistic/services/request_helper.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';

class RemontGetPage extends StatefulWidget {
  const RemontGetPage({super.key});

  @override
  State<RemontGetPage> createState() => _RemontGetPageState();
}

class _RemontGetPageState extends State<RemontGetPage> {
  File? photoFile;
  File? videoFile;

  final picker = ImagePicker();

  final TextEditingController workDoneController = TextEditingController();
  final TextEditingController masterAmountController = TextEditingController();
  final TextEditingController sparePartController = TextEditingController();
  final TextEditingController sparePartAmountController =
      TextEditingController();
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

  Future<void> sendRemont() async {
    final userId = cache.getInt("user_id");

    final workDone = workDoneController.text.trim();
    final sparePart = sparePartController.text.trim();

    final masterAmount = int.tryParse(masterAmountController.text.trim());
    final sparePartAmount = int.tryParse(sparePartAmountController.text.trim());

    if (workDone.isEmpty ||
        sparePart.isEmpty ||
        masterAmount == null ||
        sparePartAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maydonlarni to‘g‘ri to‘ldiring")),
      );
      return;
    }

    // Upload image
    String? photoUrl;
    if (photoFile != null) {
      photoUrl = await uploadPhoto(photoFile!);
    }

    // Upload video
    String? videoUrl;
    if (videoFile != null) {
      videoUrl = await uploadVideo(videoFile!);
    }

    final body = {
      "userId": userId,
      "workDone": workDone,
      "masterAmount": masterAmount,
      "sparePart": sparePart,
      "sparePartAmount": sparePartAmount,
      "photoUrl": photoUrl,
      "videoUrl": videoUrl,
      "comment": noteController.text.trim(),
    };

    try {
      final res = await requestHelper.postWithAuth(
        "/api/v1/repairs",
        body,
        log: true,
      );

      if (res["success"] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Ma'lumot yuborildi!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Xatolik: ${res["message"]}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xatolik: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ui,
      appBar: AppBar(
        backgroundColor: AppColors.ui,
        centerTitle: true,
        title: const Text("Ta'mirlash ma'lumotlari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: workDoneController,
              hint: "Qilingan ish (misol: Dvigatel ta'mirlash)",
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: masterAmountController,
              hint: "Usta haqi (so'm)",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: sparePartController,
              hint: "Zapchast nomi",
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: sparePartAmountController,
              hint: "Zapchast summasi (so'm)",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Foto hisobot',
              fileName: photoFile != null
                  ? photoFile!.path.split('/').last
                  : "",
              onPressed: pickPhoto,
              onDelete: () => setState(() => photoFile = null),
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Video hisobot',
              fileName: videoFile != null
                  ? videoFile!.path.split('/').last
                  : "",
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
            GradientButton(onPressed: sendRemont, text: "Yuborish"),
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
      keyboardType: keyboardType,
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
