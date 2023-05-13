import 'package:js/js_util.dart';
import './downloader_js.dart';

class DownloaderPlugin {
  Future<dynamic> callDownload(
      String data, String contentType, String filename) async {
    return await promiseToFuture(download(data, contentType, filename));
  }
}
