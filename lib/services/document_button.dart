import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/style/app_style.dart';

class DocumentButton extends StatelessWidget {
  final String title;
  final String? fileName;
  final VoidCallback onPressed;
  final VoidCallback? onDelete;

  const DocumentButton({
    super.key,
    required this.title,
    this.fileName,
    required this.onPressed,
    this.onDelete,
  });

  String _shortenFileName(String name, {int maxLength = 25}) {
    if (name.length <= maxLength) return name;

    final dotIndex = name.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < name.length - 1) {
      final ext = name.substring(dotIndex);
      final nameWithoutExt = name.substring(0, dotIndex);

      final keepStart = (maxLength - ext.length - 3) ~/ 2;
      final keepEnd = (maxLength - ext.length - 3) - keepStart;

      final start = nameWithoutExt.substring(0, keepStart);
      final end = nameWithoutExt.substring(nameWithoutExt.length - keepEnd);
      return "$start...$end$ext";
    }

    return name.substring(0, maxLength - 3) + "...";
  }

  @override
  Widget build(BuildContext context) {
    final displayName = (fileName == null || fileName!.isEmpty)
        ? "-"
        : _shortenFileName(fileName!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyle.fontStyle.copyWith(
                          color: AppColors.grade1,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.fontStyle.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/trash.svg',
                      width: 18,
                      height: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
