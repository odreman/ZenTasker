import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zen_tasker/services/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: const MyMain(),
    ),
  );
}

class MyMain extends StatelessWidget {
  const MyMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Zen Tasker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
      ],
      home: MyApp(),
    );
  }
}
