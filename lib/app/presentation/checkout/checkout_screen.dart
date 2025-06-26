import 'package:dewakoding_kasir/app/domain/entity/order.dart';
import 'package:dewakoding_kasir/app/domain/entity/product.dart';
import 'package:dewakoding_kasir/app/presentation/checkout/checkout_notifier.dart';
import 'package:dewakoding_kasir/app/presentation/detail_order/detail_order_screen.dart';
import 'package:dewakoding_kasir/core/helper/date_time_helper.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/number_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends AppWidget<CheckoutNotifier, OrderEntity, void> {
  CheckoutScreen({super.key, required super.param1});
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 5,
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_outlined)),
          SizedBox(width: 70,),
          Icon(Icons.credit_card),
          SizedBox(width: 10,),
          Text('Checkout',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 30,),
        ],
      ),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return Card(
      elevation: 3,
      child: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _customerLayout(context),
              const SizedBox(
                height: 20,
              ),
              _productLayout(context),
              const SizedBox(
                height: 20,
              ),
              _paymentLayout(context),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                    onPressed: () => _onPressSend(context),
                    child: const Text('Kirim'),
                  ))
            ],
          ),
        ),
      )),
    );
  }

  @override
  checkVariable(BuildContext context) async {
    if (notifier.isSuccess) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailOrderScreen(
              param1: notifier.order!.id,
            ),
          ));
      Navigator.pop(context, true);
    }
  }

  _customerLayout(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.green.shade50,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: GlobalHelper.getColorScheme(context).shadow, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
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
                Expanded(child: Text(notifier.order?.note ?? '-'))
              ],
            )
          ],
        ),
      ),
    );
  }

  _productLayout(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.green.shade50,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: GlobalHelper.getColorScheme(context).shadow, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
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
              separatorBuilder: (context, index) => Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 0.5,
                    color: GlobalHelper.getColorScheme(context).shadow,
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
              itemCount: notifier.order!.items.length,
              itemBuilder: (context, index) {
                final item = notifier.order!.items[index];
                return _itemProductLayout(context, item);
              },
            )
          ],
        ),
      ),
    );
  }

  _paymentLayout(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.green.shade50,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: GlobalHelper.getColorScheme(context).shadow, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              'Pembayaran',
              style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.TITLE_MEDIUM),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: notifier.totalController,
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                  label: Text('Total pembayaran'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownMenu<int>(
              expandedInsets: const EdgeInsets.symmetric(horizontal: 1),
              label: const Text('Metode pembayaran'),
              controller: notifier.methodController,
              dropdownMenuEntries: notifier.listDropdownPaymentMethod,
              initialSelection: notifier.initialPaymentMethod,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  label: Text('Nominal bayar'), border: OutlineInputBorder()),
              onSubmitted: (value) => _updateChangeAmount(),
              onTapOutside: (event) => _updateChangeAmount(),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.changeController,
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                  label: Text('Kembalian'), border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  _itemProductLayout(BuildContext context, ProductItemOrderEntity item) {
    return Column(
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
    );
  }

  _updateChangeAmount() {
    notifier.updateChangeAmount();
  }

  _onPressSend(BuildContext context) {
    notifier.send();
  }
}
