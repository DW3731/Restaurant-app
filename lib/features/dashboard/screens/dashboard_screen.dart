import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/helper/disbursement_helper.dart';
import 'package:stackfood_multivendor_restaurant/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/screens/menu_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/wallet_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {

  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  DisbursementHelper disbursementHelper = DisbursementHelper();
  bool _canExit = false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const OrderHistoryScreen(),
      const RestaurantScreen(),
      const WalletScreen(),
      Container(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    showDisbursementWarningMessage();
  }

  showDisbursementWarningMessage() async {
    disbursementHelper.enableDisbursementWarningMessage(true);
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (_pageIndex != 0) {
          _setPage(0);
        } else {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Prevents the default back button
          leading: IconButton(
            icon: Icon(Icons.menu_open_sharp),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
            },
          ),
          title: Row(
            children: [
              SizedBox(width: 60), // Adjust this value to control spacing between menu and home
              IconButton(
                icon: Icon(Icons.home_outlined),
                onPressed: () => _setPage(0),
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 60), // Adjust this value to control spacing between home and shopping bag
              IconButton(
                icon: Icon(Icons.restaurant_menu),
                color: Theme.of(context).primaryColor,
                onPressed: () => _setPage(1),
              ),
              SizedBox(width: 59.4), // Adjust this value to control spacing between shopping bag and monetization
              IconButton(
                icon: Icon(Icons.monetization_on),
                color: Theme.of(context).primaryColor,
                onPressed: () => _setPage(3),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _screens.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
            Positioned(
              bottom: 71, // Adjust this value to move the button up or down from the bottom
              right: 180, // Adjust this value for horizontal positioning
              child: !GetPlatform.isMobile ? SizedBox.shrink() : Material(
                elevation: 5,
                shape: const CircleBorder(),
                child: FloatingActionButton(
                  backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                  onPressed: () => _setPage(2),
                  child: Padding(
                    padding: const EdgeInsets.all(0), // Adjust padding if necessary
                    child: Image.asset(
                      Images.restaurant, height: 45, width: 40,
                      color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
