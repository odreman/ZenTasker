import 'package:flutter/material.dart';
import 'package:zen_tasker/app/view/splash/splash_page.dart';
import 'package:zen_tasker/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: customPrimaryColor),
        scaffoldBackgroundColor: customPrimaryBackgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Epilogue',
            color: customPrimaryTextColor,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Epilogue',
            color: customPrimaryTextColor,
          ),
          // Define otros estilos de texto si los necesitas
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(customPrimaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 54)),
            textStyle: MaterialStateProperty.all(
              TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: customPrimaryTextColor,
              ),
            ),
          ),
        ),
      ),
      home: Builder(
        builder: (context) => const SplashPage(),
      ),
    );
  }
}
