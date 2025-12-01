import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xamraev_logistic/app/router.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/style/app_style.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ui,
      appBar: AppBar(
        backgroundColor: AppColors.ui,
        centerTitle: true,
        title: Text(
          'Asosiy Sahifa',
          style: AppStyle.fontStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.grade1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServiceListContainer(
              imagePath: 'petrol',
              label: 'petrol_get',
              onTap: () {
                context.push(Routes.petrolGet);
              },
            ),
            ServiceListContainer(
              imagePath: 'tire',
              label: 'shina_get',
              onTap: () {
                context.push(Routes.shinaGet);
              },
            ),
            ServiceListContainer(
              imagePath: 'oil',
              label: 'masla_get',
              onTap: () {
                context.push(Routes.maslaGet);
              },
            ),
            ServiceListContainer(
              imagePath: 'service',
              label: 'remont_get',
              onTap: () {
                context.push(Routes.remontGet);
              },
            ),
            ServiceListContainer(
              imagePath: 'other',
              label: 'other_get',
              onTap: () {
                context.push(Routes.otherGet);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceListContainer extends StatelessWidget {
  const ServiceListContainer({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  final String label;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grade1.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grade1.withOpacity(0.3)),
            color: AppColors.grade1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/$imagePath.svg',
            width: 40,
            height: 40,
            color: AppColors.grade1,
          ),
        ),
        title: Text(
          label.tr(),
          style: AppStyle.fontStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
