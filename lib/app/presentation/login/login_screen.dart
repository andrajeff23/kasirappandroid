import 'package:dewakoding_kasir/app/presentation/home/home_screen.dart';
import 'package:dewakoding_kasir/app/presentation/login/login_notifier.dart';
import 'package:dewakoding_kasir/core/helper/dialog_helper.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends AppWidget<LoginNotifier, void, void> {
  LoginScreen({super.key});

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () => _onPressUrlButton(context),
                    icon: const Icon(Icons.link))),
            Expanded(
              child: Center(
                  child: Image.asset(
                "assets/logo.png",
                // width: 240,
                // height: 240,
              )),
            ),
            TextField(
              controller: notifier.emailController,
              decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: notifier.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: () => _onPressLogin(context),
                    child: const Text('Login'))),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    ));
  }

  @override
  checkVariable(BuildContext context) {
    if (notifier.isLogged) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
    return super.checkVariable(context);
  }

  _onPressUrlButton(BuildContext context) {
    DialogHelper.showBottomSheetDialog(
        context: context,
        title: 'Pengaturan Base URL',
        content: Column(
          children: [
            TextField(
              controller: notifier.baseUrlController,
              decoration: const InputDecoration(
                  label: Text('Base URL'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: () => _onPressSaveBaseUrl(context),
                    child: const Text('Simpan')))
          ],
        ));
  }

  _onPressLogin(BuildContext context) {
    notifier.login();
  }

  _onPressSaveBaseUrl(BuildContext context) {
    notifier.saveBaseUrl();
    Navigator.pop(context);
  }
}
