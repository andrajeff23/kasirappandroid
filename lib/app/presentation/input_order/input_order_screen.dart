import 'package:dewakoding_kasir/app/domain/entity/product.dart';
import 'package:dewakoding_kasir/app/presentation/add_product_order/add_product_order_screen.dart';
import 'package:dewakoding_kasir/app/presentation/checkout/checkout_screen.dart';
import 'package:dewakoding_kasir/app/presentation/input_order/input_order_notifier.dart';
import 'package:dewakoding_kasir/core/helper/date_time_helper.dart';
import 'package:dewakoding_kasir/core/helper/dialog_helper.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/number_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class InputOrderScreen extends AppWidget<InputOrderNotifier, void, void> {
  InputOrderScreen({super.key});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 5,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_outlined)),
          SizedBox(width: 40,),

          Icon(Icons.add_business_sharp),
          SizedBox(width: 10,),
          Text('Create Order',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () => _showDialogCustomer(context),
            icon: const Icon(Icons.person))
      ],
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
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Produk Dipesan',
                    style: GlobalHelper.getTextTheme(context,
                            appTextStyle: AppTextStyle.TITLE_LARGE)
                        ?.copyWith(
                            color: GlobalHelper.getColorScheme(context).primary),
                  )),
                  IconButton.outlined(
                      onPressed: () => _onPressBarcode(context),
                      icon: const Icon(Icons.qr_code_scanner)),
                  IconButton.filled(
                      onPressed: () => _onPressAddProduct(context),
                      icon: const Icon(Icons.add))
                ],
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
                itemCount: notifier.listOrderItem!.length,
                itemBuilder: (context, index) {
                  final item = notifier.listOrderItem![index];
                  return _itemOrderLayout(context, item);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                      onPressed: () => _onPressCheckout(context),
                      child: const Text('Checkout')))
            ],
          ),
        ),
      )),
    );
  }

  @override
  checkVariable(BuildContext context) {
    if (notifier.isShowCustomer || notifier.errorCustomer.isNotEmpty) {
      notifier.isShowCustomer = false;
      _showDialogCustomer(context);
    }
  }

  _itemOrderLayout(BuildContext context, ProductItemOrderEntity item) {
    return Card(
      elevation: 3,
      color: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
                color: GlobalHelper.getColorScheme(context).shadow, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  item.name,
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.LABEL_LARGE),
                )),
                Text(
                  NumberHelper.formatIdr(item.price),
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_LARGE)
                      ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GlobalHelper.getColorScheme(context).primary),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Stok : ${item.stock}',
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_MEDIUM),
                ),
                const Expanded(child: SizedBox()),
                IconButton.outlined(
                    onPressed: () => _onPressRemoveQuantity(item),
                    icon: const Icon(Icons.remove)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: GlobalHelper.getColorScheme(context).shadow,
                          width: 0.5),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    item.quantity.toString(),
                    style: GlobalHelper.getTextTheme(context,
                        appTextStyle: AppTextStyle.BODY_LARGE),
                  ),
                ),
                IconButton.outlined(
                    onPressed: (item.stock != null &&
                            item.stock! > 0 &&
                            item.stock! > item.quantity)
                        ? () => _onPressAddQuantity(item)
                        : null,
                    icon: const Icon(Icons.add))
              ],
            )
          ],
        ),
      ),
    );
  }

  _showDialogCustomer(BuildContext context) {
    DialogHelper.showBottomSheetDialog(
        context: context,
        title: 'Pembeli',
        content: Column(
          children: [
            TextField(
              controller: notifier.nameController,
              decoration: InputDecoration(
                  label: const Text('Nama'),
                  border: const OutlineInputBorder(),
                  errorText: notifier.errorCustomer[InputOrderNotifier.NAME]),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownMenu<String>(
              expandedInsets: const EdgeInsets.symmetric(horizontal: 1),
              label: const Text('Gender'),
              dropdownMenuEntries: notifier.genderListDropdown ?? [],
              controller: notifier.genderController,
              errorText: notifier.errorCustomer[InputOrderNotifier.GENDER],
              // initialSelection: notifier.genderController.text == 'Jenis Kelamin' ? null : notifier.genderController.text,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.notesController,
              decoration: const InputDecoration(
                  label: Text('Notes'), border: OutlineInputBorder()),
              maxLines: null,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text('Email'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  label: Text('Phone'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              onTap: () => _onPressBirthDay(context),
              controller: notifier.birthdayController,
              decoration: const InputDecoration(
                  label: Text('Birthday'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: () => _onPressSaveCustomer(context),
                    child: const Text('Simpan')))
          ],
        ));
  }

  _onPressBirthDay(BuildContext context) async {
    DateTime? birthday = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
    notifier.birthdayController.text =
        DateTimeHelper.formatDateTime(dateTime: birthday, format: 'yyyy-MM-dd');
  }

  _onPressSaveCustomer(BuildContext context) {
    Navigator.pop(context);
    notifier.validateCustomer();
  }

  _onPressAddProduct(BuildContext context) async {
    final List<ProductItemOrderEntity>? items = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductOrderScreen(
            param1: notifier.listOrderItem,
          ),
        ));
    if (items != null) notifier.updateItems(items);
  }

  _onPressBarcode(BuildContext context) {
    QrBarCodeScannerDialog().getScannedQrBarCode(
        context: context,
        onCode: (code) {
          notifier.scan(code ?? '');
        });
  }

  _onPressRemoveQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity - 1);
  }

  _onPressAddQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity + 1);
  }

  _onPressCheckout(BuildContext context) async {
    bool? isDone = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(param1: notifier.order),
        ));
    if (isDone ?? false) Navigator.pop(context);
  }
}
