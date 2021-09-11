import 'package:counter_notification/controller/countercontroller.dart';
import 'package:counter_notification/service/notification.dart';
import 'package:counter_notification/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notification channel
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
  // Register the Get controller to app
  Get.put(CounterController());
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  // Instence of Storage calss
  final storage = LocalStorage();
  // Instence of NotificationService calss
  final notification = NotificationService();
  // Initilaize controller using Controller class
  final controller = Get.put(CounterController());

// Getting stored counter value if file is precent pass value otherwise pass 0
  readCounter() async {
    try {
      String data = await storage.readData();
      controller.initilaizeCounter(int.parse(data));
    } catch (e) {
      controller.initilaizeCounter(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size of device for resizing widget and give size to font
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var scrWidth = MediaQuery.of(context).size.width / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    // initialize notification listener for action button in notification
    notification.notifyListener();

    readCounter();
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter Notifiaction"),
      ),
      body: Container(
        width: double.infinity,
        // GetBuilder used to update the widget whenever the update() is called which is precent in controller class
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
                          // increament counter
                          int count = controller.inc();
                          // store the counter to file
                          storage.writeData(count.toString());
                          // reassign the counter value from file
                          await readCounter();
                          // send notification to phone
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
