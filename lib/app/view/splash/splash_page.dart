import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_tasker/app/view/onboarding/onboarding_page.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/app/view/task_list/task_list_page.dart';

//splash screen
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: const TitleH1('Zen Tasker'),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topCenter,
              child: Center(
                child: Lottie.asset('assets/lottie/intro.json'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    await Future.delayed(const Duration(seconds: 4), () {
      if (_seen) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TaskListPage()),
        );
      } else {
        prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    });
  }
}
