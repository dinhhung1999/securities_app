

import 'package:securities_app/application.dart';
import 'package:securities_app/global/socket/socket_data_center.dart';

void injectSocket() {
  sl.registerLazySingleton(() => SocketDataCenter());
}