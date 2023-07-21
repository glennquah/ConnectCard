import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/qrcode_scanner.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Share via')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            onPressed: () async {
                              // Share the QR code image using WhatsApp
                              final ByteData? qrCodeByteData = await QrPainter(
                                data: userData.uid,
                                version: QrVersions.auto,
                              ).toImageData(150);

                              if (qrCodeByteData != null) {
                                _shareToWhatsApp(
                                    qrCodeByteData.buffer.asUint8List());
                              }
                            },
                            icon: Image.asset('assets/logo/whatsapp.png'),
                          ),
                        ),
                        Text('WhatsApp'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            onPressed: () async {
                              // Share the QR code image using Telegram
                              final ByteData? qrCodeByteData = await QrPainter(
                                data: userData.uid,
                                version: QrVersions.auto,
                              ).toImageData(150);

                              if (qrCodeByteData != null) {
                                _shareToTelegram(
                                    qrCodeByteData.buffer.asUint8List());
                              }
                            },
                            icon: Image.asset('assets/logo/telegram.png'),
                          ),
                        ),
                        Text('Telegram'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
                      onPressed: () {
                        _showShareDialog(context);
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
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 50),
              ElevatedButton(
                onPressed: () {
                  _showConnectDialog(context);
                },
                child: Text('Connect'),
              ),
              IconButton(
                onPressed: () {
                  _showShareDialog(context); // Un-commented the method call
                },
                icon: Icon(Icons.share),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _shareToWhatsApp(Uint8List qrCodeImageData) async {
    try {
      // Generate the QR code image with a white background
      final qrCodeWithWhiteBackground =
          await _generateQRCodeWithWhiteBackground(qrCodeImageData);

      // Share the image using modern_form_esys_flutter_share package
      final ByteData data =
          ByteData.sublistView(qrCodeWithWhiteBackground.buffer.asByteData());
      await Share.file(
        'QR Code',
        'qrcode.png',
        data.buffer.asUint8List(),
        'image/png',
        text:
            'Hello! To add me as a friend on ConnectCard, Please scan my QR Code!',
      );
    } catch (e) {
      print('Error sharing to WhatsApp: $e');
    }
  }

  Future<void> _shareToTelegram(Uint8List qrCodeImageData) async {
    try {
      // Generate the QR code image with a white background
      final qrCodeWithWhiteBackground =
          await _generateQRCodeWithWhiteBackground(qrCodeImageData);

      // Share the image using modern_form_esys_flutter_share package
      final ByteData data =
          ByteData.sublistView(qrCodeWithWhiteBackground.buffer.asByteData());
      await Share.file(
        'QR Code',
        'qrcode.png',
        data.buffer.asUint8List(),
        'image/png',
        text:
            'Hello! To add me as a friend on ConnectCard, Please scan my QR Code!',
      );
    } catch (e) {
      print('Error sharing to Telegram: $e');
    }
  }

  Future<Uint8List> _generateQRCodeWithWhiteBackground(
      Uint8List qrCodeImageData) async {
    // Create a blank canvas with a white background
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas =
        Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(200, 200)));
    canvas.drawColor(Colors.white, BlendMode.color);

    // Load the original QR code image onto the canvas
    final ByteData data =
        ByteData.sublistView(qrCodeImageData.buffer.asByteData());
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image qrImage = frameInfo.image;

    // Draw the QR code image on the canvas with a white background
    canvas.drawImage(qrImage, Offset(0, 0), Paint());

    // End drawing
    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(200, 200);
    final ByteData? pngBytes =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }
}
