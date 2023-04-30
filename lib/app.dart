import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/pages/FeatureModule.dart';
import 'package:smartstock/core/services/util.dart';

class SmartStockCoreModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;
  final Map<String, Module Function(OnGetModulesMenu)> coreModules;
  final Map<String, FeatureModule Function(OnGetModulesMenu)> featureModules;

  SmartStockCoreModule({
    required this.onGetModulesMenu,
    required this.coreModules,
    required this.featureModules,
  }) : super();

  @override
  List<ModularRoute> get routes => [
        ...coreModules.keys
            .map((e) =>
                ModuleRoute(e, module: coreModules[e]!(onGetModulesMenu)))
            .toList(),
        ...featureModules.keys
            .map((e) =>
                ModuleRoute(e, module: featureModules[e]!(onGetModulesMenu)))
            .toList(),
      ];

  @override
  List<Bind> get binds => [];
}
