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
      home: MyHomePage(title: 'Flutter Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = LocalStorage();
  final notification = NotificationService();
  final controller = Get.put(CounterController());

  @override
  void initState() {
    super.initState();
    notification.notifyListener();
    readCounter();
  }

  readCounter() async {
    String data = await storage.readData();
    controller.counter = int.parse(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var scrWidth = MediaQuery.of(context).size.width / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
