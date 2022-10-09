import 'package:smartstock/core/services/util.dart';
import 'package:workmanager/workmanager.dart';

oneTimeLocalSyncs() async {
  if (isNativeMobilePlatform()) {
    Workmanager().registerOneOffTask('bg-onetime', 'bg-onetime',
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(networkType: NetworkType.connected));
  }
}
