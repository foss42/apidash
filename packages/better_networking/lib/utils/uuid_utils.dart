import 'package:uuid/uuid.dart';

const uuid = Uuid();


String getNewUuid() {
  return uuid.v1();
}