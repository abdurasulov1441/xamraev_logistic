import 'package:flutter/material.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/style/app_style.dart';

class GradientButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String text;
  final bool isDisabled;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isDisabled = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool isLoading = false;

  Future<void> handlePress() async {
    if (widget.onPressed == null || widget.isDisabled) return;

    setState(() => isLoading = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.isDisabled || isLoading;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: disabled ? Colors.grey : AppColors.grade1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: disabled ? null : handlePress,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  widget.text,
                  style: AppStyle.fontStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
