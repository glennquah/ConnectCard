import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(UserData userData) async {
    // URL that we are returning
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://connectcard.page.link',
      link: Uri.parse('https://connectcard.page.link/Zi7X?id=${userData.uid}'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.connectcard',
        minimumVersion: 30,
      ),
      /* iOS parameters if needed
      iosParameters: IOSParameters(
        bundleId: 'com.example.app.ios',
        appStoreId: '123456789',
        minimumVersion: '1.0.1',
      ), */
    );

    final ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri url = dynamicLink.shortUrl;
    final String linkMessage = url.toString();

    return linkMessage;
  }
}
