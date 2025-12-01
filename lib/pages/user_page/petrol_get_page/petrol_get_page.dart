import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xamraev_logistic/services/db/cache.dart';
import 'package:xamraev_logistic/services/document_button.dart';
import 'package:xamraev_logistic/services/gradientbutton.dart';
import 'package:xamraev_logistic/services/request_helper.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/style/app_style.dart';

class PetrolGetPage extends StatefulWidget {
  const PetrolGetPage({super.key});

  @override
  State<PetrolGetPage> createState() => _PetrolGetPageState();
}

class _PetrolGetPageState extends State<PetrolGetPage> {
  String? selectedFuelType;
  File? photoFile;
  File? videoFile;

  final ImagePicker picker = ImagePicker();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController speedometerController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> pickPhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) setState(() => photoFile = File(file.path));
  }

  Future<void> pickVideo() async {
    final XFile? file = await picker.pickVideo(source: ImageSource.camera);
    if (file != null) setState(() => videoFile = File(file.path));
    return;
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

  Future<void> sendPetrol() async {
    if (selectedFuelType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Yoqilg‘i turini tanlang")));
      return;
    }

    final userId = cache.getInt("user_id");

    int fuelTypeId = switch (selectedFuelType) {
      "benzin" => 1,
      "gaz" => 2,
      "solyarka" => 3,
      "diesel" => 4,
      _ => 1,
    };

    // 1️⃣ Foto yuklash
    String? photoFilename;
    if (photoFile != null) {
      photoFilename = await uploadPhoto(photoFile!);
    }

    // 2️⃣ Video yuklash
    String? videoFilename;
    if (videoFile != null) {
      videoFilename = await uploadVideo(videoFile!);
    }

    // 3️⃣ Asosiy POST /refuels
    final body = {
      "userId": userId,
      "fuelTypeId": fuelTypeId,
      "cubLitr": int.parse(amountController.text),
      "amount": int.parse(priceController.text),
      "odometer": int.parse(speedometerController.text),
      "photoUrl": photoFilename,
      "videoUrl": videoFilename,
      "comment": noteController.text.trim(),
    };

    try {
      final res = await requestHelper.postWithAuth(
        "/api/v1/refuels",
        body,
        log: true,
      );

      if (res["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Muvaffaqiyatli yuborildi!")),
        );
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

  void openFuelTypeSelector() {
    showModalBottomSheet(
      backgroundColor: AppColors.ui,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FuelTypeBottomSheet(
        onSelect: (value) {
          setState(() => selectedFuelType = value);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ui,
      appBar: AppBar(
        backgroundColor: AppColors.ui,
        centerTitle: true,
        title: const Text('Yoqilg\'i maʼlumotlari'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomButton(
              label: selectedFuelType == null
                  ? 'Yoqilg\'i turini tanlang'
                  : selectedFuelType!,
              onTap: openFuelTypeSelector,
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: amountController,
              hint: selectedFuelType == 'gaz'
                  ? 'Miqdor (kub)'
                  : 'Miqdor (litr)',
            ),

            const SizedBox(height: 16),
            CustomTextField(controller: priceController, hint: "Narxi (so'm)"),

            const SizedBox(height: 16),
            CustomTextField(
              controller: speedometerController,
              hint: 'Spidometr koʼrsatkichi',
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Rasm olish',
              fileName: photoFile != null
                  ? photoFile!.path.split('/').last
                  : '',
              onPressed: pickPhoto,
              onDelete: () => setState(() => photoFile = null),
            ),

            const SizedBox(height: 16),
            DocumentButton(
              title: 'Video olish',
              fileName: videoFile != null
                  ? videoFile!.path.split('/').last
                  : '',
              onPressed: pickVideo,
              onDelete: () => setState(() => videoFile = null),
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: noteController,
              hint: 'Izoh...',
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            GradientButton(onPressed: sendPetrol, text: 'Yuborish'),
          ],
        ),
      ),
    );
  }
}

class FuelTypeBottomSheet extends StatelessWidget {
  const FuelTypeBottomSheet({super.key, required this.onSelect});
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grade1.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          FuelTypeItem(label: 'Benzin', value: 'benzin', onSelect: onSelect),
          FuelTypeItem(label: 'Gaz', value: 'gaz', onSelect: onSelect),
          FuelTypeItem(
            label: 'Solyarka',
            value: 'solyarka',
            onSelect: onSelect,
          ),
          FuelTypeItem(label: 'Dizel', value: 'diesel', onSelect: onSelect),
        ],
      ),
    );
  }
}

class FuelTypeItem extends StatelessWidget {
  const FuelTypeItem({
    super.key,
    required this.label,
    required this.value,
    required this.onSelect,
  });
  final String label;
  final String value;
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grade1.withOpacity(0.3)),
      ),
      child: ListTile(title: Text(label), onTap: () => onSelect(value)),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.grade1.withOpacity(0.3)),
          ),
        ),

        onPressed: onTap,
        child: Text(
          label,
          style: AppStyle.fontStyle.copyWith(color: AppColors.grade1),
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grade1.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grade1),
        ),

        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
