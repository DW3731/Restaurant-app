import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/domain/models/menu_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> menuList = [
      MenuModel(icon: Images.profile, title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(
        icon: Images.addFood, title: 'add_food'.tr, route: RouteHelper.getAddProductRoute(null),
        isBlocked: !Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!,
      ),
      MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()),
      MenuModel(icon: Images.adsMenu, title: 'advertisements'.tr, route: RouteHelper.getAdvertisementListRoute()),
      MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()),
      MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()),
      MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute()),
      MenuModel(icon: Images.review, title: 'reviews'.tr, route: RouteHelper.getCustomerReviewRoute()),
      MenuModel(icon: Images.reportsIcon, title: 'reports'.tr, route: RouteHelper.getReportsRoute()),

      if (Get.find<SplashController>().configModel!.disbursementType == 'automated')
        MenuModel(icon: Images.disbursementIcon, title: 'disbursement'.tr, route: RouteHelper.getDisbursementMenuRoute()),

      MenuModel(icon: Images.language, title: 'language'.tr, route: RouteHelper.getLanguageRoute('1'), isLanguage: true),
      MenuModel(
        icon: Images.chat, title: 'conversation'.tr, route: RouteHelper.getConversationListRoute(),
        isNotSubscribe: (Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'
            && Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0),
      ),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()),
      MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()),
      MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''),
    ];

    // Add "Story" menu option
    menuList.insert(3, MenuModel(icon: Images.story, title: 'add_story'.tr, route: RouteHelper.getStoryRoute()));

    if (Get.find<ProfileController>().profileModel!.subscription != null) {
      menuList.insert(11, MenuModel(icon: Images.subscription, title: 'my_subscription'.tr, route: RouteHelper.getSubscriptionViewRoute()));
    }

    if (Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1) {
      menuList.insert(6, MenuModel(icon: Images.deliveryMan, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: index == 0
                ? CircleAvatar(
              backgroundImage: NetworkImage(Get.find<ProfileController>().profileModel!.imageFullUrl ?? Images.placeholder), // Load the user's actual photo
              radius: 16,
            )
                : Image.asset(
              menuList[index].icon,
              width: 24,
              height: 24,
              color: Theme.of(context).primaryColor, // Use the primary color of the theme
            ),
            title: Text(menuList[index].title, style: TextStyle(fontSize: 16)),
            onTap: () {
              if (menuList[index].route.isNotEmpty) {
                Get.toNamed(menuList[index].route);
              }
            },
          );
        },
      ),
    );
  }
}
