import 'dart:async';
import 'dart:ui' as ui;

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/qrcode_scanner.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  void _showConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(userData.profilePic),
                  backgroundColor: Colors.grey,
                  child: userData.profilePic.isNotEmpty
                      ? null
                      : Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.white,
                        ),
                ),
                SizedBox(height: 16.0),
                Text(
                  userData.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: QrImageView(
                    data: userData.uid, // Provide the data here
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
                SizedBox(height: 16.0),
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
                      child: Text('Scan'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Share the QR code image using WhatsApp
                        final ByteData? qrCodeByteData = await QrPainter(
                          data: userData.uid,
                          version: QrVersions.auto,
                          gapless:
                              true, // Set this to true to avoid gaps around the QR code
                        ).toImageData(200);

                        if (qrCodeByteData != null) {
                          _share(qrCodeByteData.buffer.asUint8List());
                        }
                      },
                      child: Text('Share'),
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
        SizedBox(height: 10.0),
        Align(
          alignment: Alignment.center, // Center the Row horizontally
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showConnectDialog(context);
                },
                child: Text('Connect'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _share(Uint8List qrCodeImageData) async {
    try {
      final qrCodeWithLogo = await _generateQRCodeWithLogo(qrCodeImageData);

      // Share the image using modern_form_esys_flutter_share package
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
    // Create a blank canvas with a white background
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset.zero, Offset(250, 250))); // Increased canvas size
    canvas.drawColor(Colors.yellow[800]!, BlendMode.color);

    // Load the original QR code image onto the canvas
    final ByteData data =
        ByteData.sublistView(qrCodeImageData.buffer.asByteData());
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image qrImage = frameInfo.image;

    // Calculate the position to centralize the QR code
    final double qrSize = 200.0; // Adjust the QR code size as needed
    final double qrX = (250 - qrSize) / 2; // Center the QR code horizontally
    final double qrY = (250 - qrSize) / 2; // Center the QR code vertically

    // Draw the QR code image on the canvas with a white background
    canvas.drawImageRect(
      qrImage,
      Rect.fromLTRB(0, 0, qrImage.width.toDouble(), qrImage.height.toDouble()),
      Rect.fromLTRB(qrX, qrY, qrX + qrSize, qrY + qrSize),
      Paint(),
    );

    // End drawing
    final ui.Picture picture = recorder.endRecording();
    final ui.Image img =
        await picture.toImage(250, 250); // Increased canvas size
    final ByteData? pngBytes =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }
}
