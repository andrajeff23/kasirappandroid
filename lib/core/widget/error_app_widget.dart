import 'package:dewakoding_kasir/app/presentation/login/login_screen.dart';
import 'package:dewakoding_kasir/core/helper/global_helper.dart';
import 'package:dewakoding_kasir/core/helper/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class ErrorAppWidget extends StatelessWidget {
  final String description;
  final void Function() onPressButton;
  const ErrorAppWidget(
      {super.key, required this.description, required this.onPressButton});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Icon(
                Icons.error,
                size: 100,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Kesalahan!',
                style: GlobalHelper.getTextTheme(context,
                        appTextStyle: AppTextStyle.HEADLINE_SMALL)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                description,
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_LARGE),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              (description.contains('401') ||
                      description.toLowerCase().contains('unauthenticated'))
                  ? FilledButton(
                      onPressed: () async {
                        await SharedPreferencesHelper.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Logout'))
                  : FilledButton.icon(
                      onPressed: onPressButton,
                      label: const Text('Muat ulang'),
                      icon: const Icon(Icons.refresh),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
