class App {
  final String applicationId;
  final String projectId;
  final String? functionsURL;
  final String? databaseURL;
  final String? appPassword;

  App({
    required this.applicationId,
    required this.projectId,
    this.functionsURL,
    this.databaseURL,
    this.appPassword,
  });
}