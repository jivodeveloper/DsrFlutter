import 'package:promoterapp/util/Helper.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "fetchBackground";

@pragma('vm:entry-point')
void callbackDispatcher() {

  Workmanager().executeTask((task, inputData) {

    print('Task executed: ' + task);
    fetchLocation();
    return Future.value(true);

  });

}
