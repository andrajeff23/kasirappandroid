import 'package:dewakoding_kasir/app/domain/entity/product.dart';
import 'package:dewakoding_kasir/app/presentation/checkout/checkout_notifier.dart';
import 'package:dewakoding_kasir/app/presentation/detail_order/detail_order_notifier.dart';
import 'package:dewakoding_kasir/app/presentation/print/print_screen.dart';
import 'package:dewakoding_kasir/core/helper/date_time_helper.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/number_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class DetailOrderScreen extends AppWidget<DetailOrderNotifier, int, void> {
  DetailOrderScreen({super.key, required super.param1});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      elevation: 5,
      automaticallyImplyLeading: false,
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
          SizedBox(width: 80,),
          const Icon(Icons.receipt),
          const SizedBox(
            width: 10,
          ),
          Text('Detail order',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 40,)
        ],
      ),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _customerLayout(context),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 3),
            color: GlobalHelper.getColorScheme(context).outline,
          ),
          _productLayout(context),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 3),
            color: GlobalHelper.getColorScheme(context).outline,
          ),
          _paymentLayout(context),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(10),
            child: FilledButton(
                onPressed: () => _onPressPrint(context),
                child: const Text('Print invoice')),
          )
        ],
      ),
    );
  }

  _customerLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembeli',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(
                width: 3,
              ),
              Text(': ${notifier.order!.name}')
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon((notifier.order!.gender == CheckoutNotifier.MALE)
                  ? Icons.male
                  : Icons.female),
              const SizedBox(
                width: 3,
              ),
              Text(
                  ': ${(notifier.order!.gender == CheckoutNotifier.MALE) ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 3,
              ),
              Text(': ${notifier.order!.email ?? '-'}')
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 3,
              ),
              Text(': ${notifier.order!.phone ?? '-'}')
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.event),
              const SizedBox(
                width: 3,
              ),
              Text(
                  ': ${(notifier.order!.birthday != null) ? DateTimeHelper.formatDateTimeFromString(dateTimeString: notifier.order!.birthday!, format: 'dd MMM yyyy') : '-'}')
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text('Notes : '),
          ),
          Row(
            children: [
              const SizedBox(
                width: 25,
              ),
              Expanded(child: Text(notifier.order!.note ?? '-'))
            ],
          )
        ],
      ),
    );
  }

  _productLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk Dipesan',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
            itemCount: notifier.order!.items.length,
            itemBuilder: (context, index) {
              final item = notifier.order!.items[index];
              return _itemProductLayout(context, item);
            },
          )
        ],
      ),
    );
  }

  _paymentLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan pembayaran',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(
            height: 10,
          ),
          _itemPaymentLayout(context, 'Metode pembayaran',
              notifier.order!.paymentMethod!.name),
          const SizedBox(
            height: 5,
          ),
          _itemPaymentLayout(context, 'Total bayar',
              NumberHelper.formatIdr(notifier.order!.totalPrice ?? 0)),
          const SizedBox(
            height: 5,
          ),
          _itemPaymentLayout(context, 'Nominal bayar',
              NumberHelper.formatIdr(notifier.order!.paidAmount ?? 0)),
          const SizedBox(
            height: 5,
          ),
          _itemPaymentLayout(context, 'Kembalian',
              NumberHelper.formatIdr(notifier.order!.changeAmount ?? 0)),
        ],
      ),
    );
  }

  _itemProductLayout(BuildContext context, ProductItemOrderEntity item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: GlobalHelper.getColorScheme(context).outline, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.BODY_MEDIUM),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${item.quantity} x ${NumberHelper.formatIdr(item.price)}',
              style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_LARGE)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _itemPaymentLayout(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: GlobalHelper.getTextTheme(context,
              appTextStyle: AppTextStyle.BODY_MEDIUM),
        )),
        Text(
          value,
          style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.BODY_LARGE)
              ?.copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  _onPressPrint(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrintScreen(param1: notifier.order)));
  }
}
