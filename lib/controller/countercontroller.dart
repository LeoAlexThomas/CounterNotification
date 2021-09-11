import 'package:get/get.dart';

class CounterController extends GetxController {
  int counter = 0;

// intilaize the data to counter which is get by the data from file.
  initilaizeCounter(int data) {
    counter = data;
    update();
  }

// increament the counter and update the widget by using update()
  inc() {
    counter++;

    update();
    return counter;
  }
}
