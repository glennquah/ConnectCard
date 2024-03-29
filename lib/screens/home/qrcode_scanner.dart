import 'package:camera/camera.dart';
import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/scan/ocr/result_screen.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/profile_popup.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// QR code scanner screen
class QRScanScreen extends StatefulWidget {
  final UserData myData;

  const QRScanScreen({super.key, required this.myData});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
    );

    await cameraController!.initialize();

    // To enable live QR code scanning
    cameraController!.startImageStream((CameraImage image) {});

    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  // Handle the QR code scan result
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        isScanning = false;

        String? scannedUserId = scanData.code;

        // Get the list of users (except the current user)
        DatabaseService databaseService =
            DatabaseService(uid: widget.myData.uid);
        List<UserData> users = await databaseService.getAllUsersExceptCurrent();

        // Check if the scannedUserId exists in the list of users
        bool isScannedUserExists =
            users.any((user) => user.uid == scannedUserId);

        if (isScannedUserExists) {
          // If the scannedUserId matches any user's ID, fetch the scannedUserData using StreamBuilder
          DatabaseService scannedDatabaseService =
              DatabaseService(uid: scannedUserId!);

          showDialog(
            context: context,
            builder: (context) {
              return StreamBuilder<UserData>(
                stream:
                    scannedDatabaseService.userProfile, // Stream of UserData
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Display the ProfilePopup widget when the data is available
                    UserData scannedUserData = snapshot.data!;

                    return ProfilePopup(
                      user: scannedUserData,
                      onAddFriend: () {
                        _addFriend(scannedUserData);
                      },
                    );
                  } else {
                    // Show loading indicator or any other UI while waiting for the data
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          );
        } else {
          // Show an error message if the scanned QR code does not match any user's ID
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Invalid QR code.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      isScanning =
                          true; // Reset the isScanning flag to allow further scans
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  // Add friend logic, by adding the friend's ID into the current user's friendrequestsent and the friend's friendrequestrec
  void _addFriend(UserData friendData) async {
    // Add Friend into PERSONAL friendrequestsent
    DatabaseService databaseService = DatabaseService(uid: widget.myData.uid);
    FriendsData friendsData = await databaseService.friendData.first;
    List<Friends> friendRequestsSent =
        List.from(friendsData.listOfFriendRequestsSent);
    friendRequestsSent.add(Friends(uid: friendData.uid));
    await databaseService.updateFriendDatabase(
      friendsData.listOfFriends,
      friendRequestsSent,
      friendsData.listOfFriendRequestsRec,
      friendsData.listOfFriendsPhysicalCard,
    );

    // Friend to receive the request under friendrequestrec
    DatabaseService databaseServiceFriend =
        DatabaseService(uid: friendData.uid);
    FriendsData friendsDataFriend =
        await databaseServiceFriend.friendData.first;
    List<Friends> friendRequestsReceived =
        List.from(friendsDataFriend.listOfFriendRequestsRec);
    friendRequestsReceived.add(Friends(uid: widget.myData.uid));
    await databaseServiceFriend.updateFriendDatabase(
      friendsDataFriend.listOfFriends,
      friendsDataFriend.listOfFriendRequestsSent,
      friendRequestsReceived,
      friendsDataFriend.listOfFriendsPhysicalCard,
    );

    // Show snack bar with friend request sent message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend request sent'),
        duration: Duration(
            seconds: 2), // Optional: Set the duration for the snack bar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final double aspectRatio = cameraController!.value.previewSize!.height /
        cameraController!.value.previewSize!.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: bgColor,
      ),
      body: Container(
        color: const Color(0xffFEAA1B),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Set the width of the buttons
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Hold Camera on QR Code for 2 seconds',
            )
          ],
        ),
      ),
    );
  }
}
