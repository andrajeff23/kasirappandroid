import 'package:dewakoding_kasir/app/presentation/login/login_screen.dart';
import 'package:dewakoding_kasir/app/presentation/product/product_screen.dart';
import 'package:dewakoding_kasir/app/presentation/profil/profil_notifier.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends AppWidget<ProfilNotifier, void, void> {
  ProfilScreen({super.key});

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
          SizedBox(width: 80,),
          Icon(Icons.people),
          SizedBox(width: 10,),
          Text('Profil',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(width: 50,)
        ],
      ),

    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _headerLayout(context),
            SizedBox(
              width: double.maxFinite,
              child: FilledButton(
                  onPressed: () => _onPressProduct(context),
                  child: const Text('Product')),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () => _onPressLogout(), child: const Text('Logout')))
          ],
        ),
      )),
    );
  }

  @override
  checkVariable(BuildContext context) {
    if (notifier.isLogout) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  _headerLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        CircleAvatar(
          radius: 50,
          backgroundColor: GlobalHelper.getColorScheme(context).primary,
          child: Text(
            notifier.name.substring(0, 1),
            style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.DISPLAY_MEDIUM)
                ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GlobalHelper.getColorScheme(context).onPrimary),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          notifier.name,
          style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.TITLE_LARGE)
              ?.copyWith(
                  color: GlobalHelper.getColorScheme(context).primary,
                  fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          notifier.email,
          style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.BODY_SMALL)
              ?.copyWith(color: GlobalHelper.getColorScheme(context).secondary),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  _onPressProduct(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(),
        ));
  }

  _onPressLogout() {
    notifier.logout();
  }
}
