import 'package:flutter/material.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CircleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? AppColors.grade1 : Colors.grey.shade400,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: value
            ? Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.grade1,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
