import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counter_notification/controller/countercontroller.dart';
import 'package:counter_notification/storage/storage.dart';
import 'package:get/get.dart';

class NotificationService {
  // instance of AwesomeNotifications class
  final _notification = AwesomeNotifications();
  // controller for update counter in notification button
  final controller = Get.put(CounterController());
  // instance for localstorage to write data
  final storage = LocalStorage();

  // creating the notification from given data with increament button
  createNotification(String title, String content) async {
    _notification.createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'ch1',
        title: title,
        body: content,
        notificationLayout: NotificationLayout.BigText,
        createdLifeCycle: NotificationLifeCycle.Background,
        displayedLifeCycle: NotificationLifeCycle.AppKilled,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      actionButtons: <NotificationActionButton>[
        NotificationActionButton(
          key: '1',
          label: 'Inc',
          buttonType: ActionButtonType.KeepOnTop,
        ),
      ],
    );
  }

// start the listener for action button in notification
  notifyListener() {
    _notification.actionStream.listen((event) {
      int count = controller.inc();
      storage.writeData(count.toString());
      createNotification('Counter Assignment', '$count');
    });
  }
}
