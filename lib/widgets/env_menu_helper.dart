import 'package:apidash/widgets/menu_item_card.dart';
import 'package:apidash/consts.dart';

List<ItemMenuOption> envMenuOptions(String environmentId) {
  if (environmentId == kGlobalEnvironmentId) {
    return const [ItemMenuOption.duplicate];
  }
  return ItemMenuOption.values;
}
