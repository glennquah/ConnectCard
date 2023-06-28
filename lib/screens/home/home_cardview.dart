import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';

class HomeCardView extends StatefulWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  @override
  _HomeCardViewState createState() => _HomeCardViewState();
}

class _HomeCardViewState extends State<HomeCardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
          itemCount: widget.cards.length,
          itemBuilder: (context, index, _) {
            Cards card = widget.cards[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            child: card.imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      card.imageUrl,
                                      width: 60.0,
                                      height: 60.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 40.0,
                                    color: Colors.black,
                                  ),
                          ),
                          SizedBox(width: 10.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userData.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  card.companyName.isNotEmpty
                                      ? card.companyName
                                      : "Insert Company Name",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  card.jobTitle.isNotEmpty
                                      ? card.jobTitle
                                      : "Insert Job Title",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        card.phoneNum.isNotEmpty
                            ? card.phoneNum
                            : "Insert Phone Number",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        card.email.isNotEmpty ? card.email : "Insert Email",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
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
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.cards.length,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
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
    );
  }
}
