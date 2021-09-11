import 'package:counter_notification/controller/countercontroller.dart';
import 'package:counter_notification/service/notification.dart';
import 'package:counter_notification/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'ch1',
      channelName: 'Notification',
      channelDescription: 'Details',
      enableLights: true,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ]);
  Get.put(CounterController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final storage = LocalStorage();
  final notification = NotificationService();
  final controller = Get.put(CounterController());

  readCounter() async {
    String data = await storage.readData();
    controller.initilaizeCounter(int.parse(data));
  }

  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var scrWidth = MediaQuery.of(context).size.width / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    notification.notifyListener();
    readCounter();
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter Notifiaction"),
      ),
      body: Container(
        width: double.infinity,
        child: GetBuilder<CounterController>(
            builder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: scrWidth * 40,
                      height: scrHeight * 20,
                      padding: EdgeInsets.symmetric(
                          horizontal: scrWidth * 1, vertical: scrHeight * 1),
                      child: Center(
                        child: Text(
                          '${controller.counter}',
                          style: TextStyle(fontSize: fontHeight * 7.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: scrHeight * 10,
                      width: scrWidth * 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          int count = controller.inc();
                          storage.writeData(count.toString());
                          await readCounter();
                          notification.createNotification(
                              'Counter Assignment', '$count');
                        },
                        child: Text(
                          'Increament',
                          style: TextStyle(fontSize: fontHeight * 3.5),
                        ),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
