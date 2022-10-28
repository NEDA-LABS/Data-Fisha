import 'package:smartstock/core/models/external_service.dart';

class SalesExternalServiceState {
  static final SalesExternalServiceState _singleton =
      SalesExternalServiceState._internal();

  factory SalesExternalServiceState() {
    return _singleton;
  }

  SalesExternalServiceState._internal();

  List<ExternalService> _salesExternalServices = [];

  List<ExternalService> get salesExternalServices => _salesExternalServices;

  void setSalesExternalServices(List<ExternalService> services) {
    _salesExternalServices = services;
  }
}

// class SalesExternalServiceState extends ChangeNotifier {
//   List<ExternalService> _salesExternalServices = [];
//
//   List<ExternalService> get salesExternalServices => _salesExternalServices;
//
//   void setSalesExternalServices(List<ExternalService> services) {
//     _salesExternalServices = services;
//     notifyListeners();
//   }
// }
//
// SalesExternalServiceState getSalesExternalServiceState() =>
//     getState<SalesExternalServiceState>();
