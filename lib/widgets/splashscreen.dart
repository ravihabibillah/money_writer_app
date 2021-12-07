import 'package:flutter/material.dart';
import 'package:money_writer_app/common/styles.dart';
import 'package:money_writer_app/ui/home/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splash_screen';
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });

    return Scaffold(
      backgroundColor: Pallete.tealToDark.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Money Writer',
              style: TextStyle(
                  color: Pallete.tealToDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Write and watch your expenses!',
              style: TextStyle(
                  color: Pallete.tealToDark[400], fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}
