import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/app/view/task_list/task_list_page.dart';
import 'package:zen_tasker/utils/colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late Material materialButton;
  late int index;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF171a1f);

    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: "",
            bodyWidget: const Column(
              children: [
                SizedBox(height: 40),
                TitleH1("Bienvenido a ZenTasker"),
                SizedBox(height: 10),
                Image(image: AssetImage('assets/images/onboarding_001.png')),
                SizedBox(height: 30),
                TextH2(
                    "Descubre la tranquilidad en la gestión de tareas. ZenTasker te ofrece una experiencia serena y organizada para manejar tu día a día.",
                    textAlign: TextAlign.center),
              ],
            )),
        PageViewModel(
            title: "",
            bodyWidget: const Column(
              children: [
                SizedBox(height: 40),
                TitleH1("Organiza con facilidad"),
                SizedBox(height: 10),
                Image(image: AssetImage('assets/images/onboarding_003.png')),
                SizedBox(height: 30),
                TextH2(
                    "Organizar tus tareas es sencillo y relajante. Prioriza, planifica y progresa.",
                    textAlign: TextAlign.center),
              ],
            )),
        PageViewModel(
            title: "",
            bodyWidget: const Column(
              children: [
                SizedBox(height: 40),
                TitleH1("Productividad serena"),
                SizedBox(height: 10),
                Image(image: AssetImage('assets/images/onboarding_004.png')),
                SizedBox(height: 30),
                TextH2(
                    "Alcanza tus objetivos manteniendo la calma. ZenTasker te ayuda a centrarte en lo que importante para tí.",
                    textAlign: TextAlign.center),
              ],
            )),
        PageViewModel(
            title: "",
            bodyWidget: const Column(
              children: [
                SizedBox(height: 40),
                TitleH1("Gestión efectiva del tiempo"),
                SizedBox(height: 10),
                Image(image: AssetImage('assets/images/onboarding_002.png')),
                SizedBox(height: 30),
                TextH2(
                    "Gestiona tu tiempo eficientemente. Encuentra el equilibrio perfecto entre trabajo, descanso y ocio a través de la gestión de tareas.",
                    textAlign: TextAlign.center),
              ],
            )),
      ],
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TaskListPage()),
        );
      },
      showSkipButton: true,
      skip: const TextH3("Omitir"),
      next: const TextH3("Siguiente"),
      nextStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(customPrimaryColor),
      ),
      done: const TextH3("¡Vamos!"),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
