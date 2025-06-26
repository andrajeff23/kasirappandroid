import 'package:dewakoding_kasir/app/domain/entity/product.dart';
import 'package:dewakoding_kasir/app/presentation/product/product_notifier.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/number_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:dewakoding_kasir/core/widget/image_network_app_widget.dart';
import 'package:flutter/material.dart';

class ProductScreen extends AppWidget<ProductNotifier, void, void> {
  ProductScreen({super.key});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Produk'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () => notifier.init(),
      child: ListView.separated(
        separatorBuilder: (context, index) => Container(
          height: 3,
          color: GlobalHelper.getColorScheme(context).outline,
        ),
        itemCount: notifier.listProduct.length,
        itemBuilder: (context, index) {
          final item = notifier.listProduct[index];
          return _itemLayout(context, item);
        },
      ),
    ));
  }

  _itemLayout(BuildContext context, ProductEntity item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          ImageNetworkAppWidget(
            imageUrl: item.imageUrl ?? '',
            witdh: 50,
            height: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.TITLE_SMALL),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  NumberHelper.formatIdr(item.price),
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_LARGE),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stok : ${item.stock}',
                      style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.LABEL_MEDIUM),
                    ),
                    Text(
                      (item.isActive) ? 'Active' : 'Tidak aktif',
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.LABEL_MEDIUM)
                          ?.copyWith(
                              color:
                                  (item.isActive) ? Colors.green : Colors.grey),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
