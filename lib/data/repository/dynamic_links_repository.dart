import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';

@injectable
class DynamicLinksRepository {
  final _dynamicLinks = FirebaseDynamicLinks.instance;
  final _urlPrefix = 'https://payflix.page.link';
  final _appId = 'com.piekarskipiotr.payflix';

  FirebaseDynamicLinks instance() => _dynamicLinks;

  Future<Uri> createInviteLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: _urlPrefix,
      link: Uri.parse('$_urlPrefix/invite?id=$id'),
      androidParameters: AndroidParameters(
        packageName: _appId,
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: _appId,
        minimumVersion: '0',
      ),
    );

    final dynamicLink = await _dynamicLinks.buildShortLink(parameters);
    return dynamicLink.shortUrl;
  }
}
