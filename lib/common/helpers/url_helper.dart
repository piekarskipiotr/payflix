import 'package:url_launcher/url_launcher_string.dart';

class UrlHelper {
  static void openUrl(String url) async {
    await canLaunchUrlString(url)
        ? await launchUrlString(url)
        : throw 'Error during launching website';
  }
}
