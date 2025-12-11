import 'package:dewakoding_kasir/app/domain/entity/order.dart';
import 'package:dewakoding_kasir/app/presentation/detail_order/detail_order_screen.dart';
import 'package:dewakoding_kasir/app/presentation/home/home_screen.dart';
import 'package:dewakoding_kasir/app/presentation/input_order/input_order_screen.dart';
import 'package:dewakoding_kasir/app/presentation/order/order_notifier.dart';
import 'package:dewakoding_kasir/core/helper/date_time_helper.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/number_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class OrderScreen extends AppWidget<OrderNotifier, void, void> {
  OrderScreen({super.key});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Order',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.9),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
              Theme.of(context).colorScheme.surface.withOpacity(0.95),
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => notifier.init(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: notifier.listOrder.length,
            itemBuilder: (context, index) {
              final item =
                  notifier.listOrder[notifier.listOrder.length - 1 - index];
              return _itemOrderLayout(context, item);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget? floatingActionButtonBuild(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onPressAddOrder(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.add),
    );
  }

  _itemOrderLayout(BuildContext context, OrderEntity item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: InkWell(
        onTap: () => _onPressItemOrder(context, item),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: GlobalHelper.getTextTheme(context,
                            appTextStyle: AppTextStyle.BODY_LARGE)
                        ?.copyWith(
                            color: GlobalHelper.getColorScheme(context).primary,
                            fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateTimeHelper.formatDateTimeFromString(
                        dateTimeString: item.updatedAt!,
                        format: 'dd MMM yyyy HH:mm'),
                    style: GlobalHelper.getTextTheme(context,
                            appTextStyle: AppTextStyle.BODY_SMALL)
                        ?.copyWith(
                            color:
                                GlobalHelper.getColorScheme(context).secondary),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${NumberHelper.formatIdr(item.totalPrice!)} (${item.items.length} item)',
                    style: GlobalHelper.getTextTheme(context,
                            appTextStyle: AppTextStyle.BODY_LARGE)
                        ?.copyWith(
                            color: GlobalHelper.getColorScheme(context).primary,
                            fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color:
                                GlobalHelper.getColorScheme(context).secondary),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      item.paymentMethod!.name,
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.BODY_SMALL)
                          ?.copyWith(
                              color: GlobalHelper.getColorScheme(context)
                                  .secondary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _onPressItemOrder(BuildContext context, OrderEntity item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailOrderScreen(
            param1: item.id,
          ),
        ));
    notifier.init();
  }

  _onPressAddOrder(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputOrderScreen(),
        ));
    notifier.init();
  }
}
