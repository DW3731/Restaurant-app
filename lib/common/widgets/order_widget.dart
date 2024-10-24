import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;
  const OrderWidget({super.key, required this.orderModel, required this.hasDivider, required this.isRunning, this.showStatus = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(orderModel.id), arguments: OrderDetailsScreen(
        orderModel: orderModel, isRunningOrder: isRunning,
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3)),
        ),
        child: Column(children: [

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text('order'.tr, style: robotoMedium),
                  Text(' # ${orderModel.id}', style: robotoBold),
                  Text(' (${orderModel.detailsCount} ${orderModel.detailsCount! < 2 ? 'item'.tr : 'items'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                ]),

                showStatus ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: orderModel.orderStatus == 'delivered' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    orderModel.orderStatus!.tr,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: orderModel.orderStatus == 'delivered' ? Colors.green : Colors.red,
                    ),
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt!),
                  // getChatTime(orderModel.createdAt!),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  orderModel.orderType!.tr,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: orderModel.orderType == 'delivery' ? Colors.blue : Theme.of(context).primaryColor,
                  ),
                ),

              ])),

              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  orderModel.paymentMethod == 'cash_on_delivery' ? 'amount'.tr
                      : orderModel.paymentMethod == 'wallet' ? 'wallet_payment'.tr : orderModel.paymentMethod == 'cash' ? 'cash'.tr
                      : orderModel.paymentMethod == 'digital_payment' ? 'digital_payment'.tr : orderModel.paymentMethod?.replaceAll('_', ' ')??'',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  PriceConverter.convertPrice(orderModel.orderAmount),
                  style: robotoBold,
                ),

              ]),

              // showStatus ? const SizedBox() : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),

            ]),
          ),

          // hasDivider ? Divider(color: Theme.of(context).disabledColor) : const SizedBox(),

        ]),
      ),
    );
  }

  String getChatTime(String todayChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    try{
      todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    }catch(e) {
      todayConversationDateTime = DateConverter.dateTimeStringToDate(todayChatTimeInUtc);
    }

    if (kDebugMode) {
      print("Current Message DataTime: $todayConversationDateTime");
    }

    DateTime currentDate = DateTime.now();

    if(currentDate.weekday != todayConversationDateTime.weekday && DateConverter.countDays(todayConversationDateTime) < 6){

      if((currentDate.weekday -1 == 0 ? 7 : currentDate.weekday -1) == todayConversationDateTime.weekday){
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, false);
      } else {
        chatTime = DateConverter.convertStringTimeToDateTime(todayConversationDateTime);
      }

    } else if(currentDate.weekday == todayConversationDateTime.weekday
        && DateConverter.countDays(todayConversationDateTime) < 6){
      chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, true);
    } else {
      chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
    }
    return chatTime;
  }
}