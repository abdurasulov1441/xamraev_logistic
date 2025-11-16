import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xamraev_logistic/services/style/app_colors.dart';
import 'package:xamraev_logistic/services/style/app_style.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ui,
      appBar: AppBar(
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
            // ServiceContainer(
            //   imagePath: 'petrol',
            //   label: 'petrol_get',
            //   onTap: () {},
            // ),
            // ServiceContainer(
            //   imagePath: 'shina',
            //   label: 'shina_get',
            //   onTap: () {},
            // ),
            // ServiceContainer(
            //   imagePath: 'masla',
            //   label: 'masla_get',
            //   onTap: () {},
            // ),
            // ServiceContainer(
            //   imagePath: 'remont',
            //   label: 'remont_get',
            //   onTap: () {},
            // ),
            // ServiceContainer(
            //   imagePath: 'other',
            //   label: 'other_get',
            //   onTap: () {},
            // ),
            ServiceListContainer(
              imagePath: 'petrol',
              label: 'petrol_get',
              onTap: () {},
            ),
            ServiceListContainer(
              imagePath: 'tire',
              label: 'shina_get',
              onTap: () {},
            ),
            ServiceListContainer(
              imagePath: 'oil',
              label: 'masla_get',
              onTap: () {},
            ),
            ServiceListContainer(
              imagePath: 'service',
              label: 'remont_get',
              onTap: () {},
            ),
            ServiceListContainer(
              imagePath: 'other',
              label: 'other_get',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// class ServiceContainer extends StatelessWidget {
//   const ServiceContainer({
//     super.key,
//     required this.imagePath,
//     required this.label,
//     required this.onTap,
//   });
//   final String imagePath;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(
//           left: 16.0,
//           right: 16.0,
//           top: 16.0,
//           bottom: 8.0,
//         ),
//         width: double.infinity,
//         height: 150,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/$imagePath.png'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3),
//               BlendMode.darken,
//             ),
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: Text(
//               label.tr(),
//               style: AppStyle.fontStyle.copyWith(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
        color: AppColors.ui,
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
