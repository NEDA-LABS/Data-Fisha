import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/util.dart';

class SmartStockCoreModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;
  final Map<String, Module Function(OnGetModulesMenu)> coreModules;

  SmartStockCoreModule(
      {required this.onGetModulesMenu, required this.coreModules})
      : super();

  @override
  List<ModularRoute> get routes => coreModules.keys
      .map((e) => ModuleRoute(e, module: coreModules[e]!(onGetModulesMenu)))
      .toList();

  @override
  List<Bind> get binds => [];
}
