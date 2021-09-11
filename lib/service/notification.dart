import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counter_notification/controller/countercontroller.dart';
import 'package:counter_notification/storage/storage.dart';
import 'package:get/get.dart';

class NotificationService {
  final _notification = AwesomeNotifications();
  final controller = Get.put(CounterController());
  final storage = LocalStorage();

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

  notifyListener() {
    print('object');
    _notification.actionStream.listen((event) {
      int count = controller.inc();
      storage.writeData(count.toString());
      createNotification('Counter Assignment', '$count');
    });
  }
}
