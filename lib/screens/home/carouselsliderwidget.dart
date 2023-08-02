import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/card_details.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// This class is used to display the carousel slider widget
class CarouselSliderWidget extends StatefulWidget {
  final UserData userData;
  final List<Cards> cards;
  final Color backgroundColor;

  const CarouselSliderWidget(
      {super.key,
      required this.userData,
      required this.cards,
      this.backgroundColor = Colors.white});

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _currentIndex = 0;

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.cards[_currentIndex].cardName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: CarouselSlider.builder(
              itemCount: widget.cards.length,
              itemBuilder: (context, index, _) {
                Cards card = widget.cards[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetailsPage(
                          card: card,
                          userData: widget.userData,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 200,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.grey,
                                    child: card.imageUrl.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              card.imageUrl,
                                              width: 60.0,
                                              height: 60.0,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 40.0,
                                            color: Colors.white,
                                          ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.userData.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            card.companyName.isNotEmpty
                                                ? card.companyName
                                                : "Insert Company Name",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          Text(
                                            card.jobTitle.isNotEmpty
                                                ? card.jobTitle
                                                : "Insert Job Title",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () async {
                                  final Uri phoneUrl =
                                      Uri(scheme: 'tel', path: card.phoneNum);
                                  if (await canLaunchUrl(phoneUrl)) {
                                    await launchUrl(phoneUrl);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Phone app not found'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Container(
                                          child: Text(
                                            card.phoneNum.isNotEmpty
                                                ? card.phoneNum
                                                : "Insert Phone Number",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  card.phoneNum.isNotEmpty
                                                      ? TextDecoration.underline
                                                      : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: card.email,
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject': 'From ConnectCard',
                                      'body':
                                          'Dear ${widget.userData.name},\n\n',
                                    }),
                                  );
                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(emailUri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No email client found'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Container(
                                          child: Text(
                                            card.email.isNotEmpty
                                                ? card.email
                                                : "Insert Email",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration: card.email.isNotEmpty
                                                  ? TextDecoration.underline
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final String companyWebsite =
                                      card.companyWebsite;
                                  final String prefixedUrl =
                                      companyWebsite.startsWith('http')
                                          ? companyWebsite
                                          : 'https://$companyWebsite';

                                  final Uri _url = Uri.parse(prefixedUrl);
                                  if (await canLaunchUrl(_url)) {
                                    await launchUrl(_url);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Website not found'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.public,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Container(
                                          child: Text(
                                            card.companyWebsite.isNotEmpty
                                                ? card.companyWebsite
                                                : "Insert Company Website",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  card.companyWebsite.isNotEmpty
                                                      ? TextDecoration.underline
                                                      : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200.0,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                initialPage: 0,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                onPageChanged: (index, _) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.cards.length,
              (index) => Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Colors.grey[900]
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
