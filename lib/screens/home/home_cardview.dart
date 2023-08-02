import 'dart:async';
import 'dart:ui' as ui;

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/carouselsliderwidget.dart';
import 'package:connectcard/screens/home/qrcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Home page for user to view their cards in cardview by using the carousel slider
class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  const HomeCardView({
    super.key,
    required this.userData,
    required this.cards,
  });

  // Show the QR code dialog when the user taps on the Connect button
  void _showConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(userData.profilePic),
                  backgroundColor: Colors.grey,
                  child: userData.profilePic.isNotEmpty
                      ? null
                      : const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  userData.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: QrImageView(
                    data: userData.uid, // chaing the uid to QR Code
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QRScanScreen(myData: userData),
                          ),
                        );
                      },
                      child: const Text('Scan'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        // convert uid to QR Code
                        final ByteData? qrCodeByteData = await QrPainter(
                          data: userData.uid,
                          version: QrVersions.auto,
                          gapless: true, //to avoid gaps around the QR code
                        ).toImageData(200);

                        if (qrCodeByteData != null) {
                          _share(qrCodeByteData.buffer.asUint8List());
                        }
                      },
                      child: const Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        CarouselSliderWidget(
          userData: userData,
          cards: cards,
        ),
        const SizedBox(height: 10.0),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showConnectDialog(context);
                },
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Share the QR code image to other apps
  Future<void> _share(Uint8List qrCodeImageData) async {
    try {
      final qrCodeWithLogo = await _generateQRCodeWithLogo(qrCodeImageData);
      final ByteData data =
          ByteData.sublistView(qrCodeWithLogo.buffer.asByteData());
      await Share.file(
        'QR Code',
        'qrcode.png',
        data.buffer.asUint8List(),
        'image/png',
        text:
            'Hello! To add me as a friend on ConnectCard, Please scan my QR Code!',
      );
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  Future<Uint8List> _generateQRCodeWithLogo(Uint8List qrCodeImageData) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    // Create a canvas with a yellow background
    final Canvas canvas =
        Canvas(recorder, Rect.fromPoints(Offset.zero, const Offset(250, 250)));
    canvas.drawColor(const Color(0xffFEAA1B), BlendMode.color);

    // Load the original QR code image onto the canvas
    final ByteData data =
        ByteData.sublistView(qrCodeImageData.buffer.asByteData());
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image qrImage = frameInfo.image;

    // Calculate the position to centralize the QR code
    final double qrSize = 200.0;
    final double qrX = (250 - qrSize) / 2;
    final double qrY = (250 - qrSize) / 2;

    canvas.drawImageRect(
      qrImage,
      Rect.fromLTRB(0, 0, qrImage.width.toDouble(), qrImage.height.toDouble()),
      Rect.fromLTRB(qrX, qrY, qrX + qrSize, qrY + qrSize),
      Paint(),
    );

    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(250, 250);
    final ByteData? pngBytes =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }
}
