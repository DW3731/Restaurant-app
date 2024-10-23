import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class OrderSummaryCard extends StatelessWidget {
  final ProfileController profileController;
  const OrderSummaryCard({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Color(0xFFFBEBEB), // Light pink color #FBEBEB
      ),

      child: Column(children: [

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Image.asset(Images.wallet, width: 150, height: 150),
          const SizedBox(width: Dimensions.paddingSizeLarge),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              'today'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.todaysEarning) : '0',
              style: robotoBold.copyWith(fontSize: 24, color: Colors.black), textDirection: TextDirection.ltr,
            ),

          ]),

        ]),
        const SizedBox(height: 30),

        Row(children: [

          Expanded(child: Column(children: [

            Text(
              'this_week'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.thisWeekEarning) : '0',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.black), textDirection: TextDirection.ltr,
            ),

          ])),

          Container(height: 30, width: 1, color: Colors.black),

          Expanded(child: Column(children: [

            Text(
              'this_month'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.thisMonthEarning) : '0',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.black),textDirection: TextDirection.ltr,
            ),

          ])),

        ]),

      ]),
    );
  }
}
