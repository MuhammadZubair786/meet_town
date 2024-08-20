import 'package:flutter/material.dart';
import 'package:meettown/res/components/location_carts.dart';
import 'package:meettown/view/profile_view/profile_view.dart';

class LoactionView extends StatelessWidget {
  const LoactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 170,
        crossAxisCount: 3,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
             Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileView(
                    name: "Name 27",
                  )));
          },
          child: LocationCart(userImage: 'https://img.freepik.com/free-photo/close-up-portrait-young-bearded-man-white-shirt-jacket-posing-camera-with-broad-smile-isolated-gray_171337-629.jpg?w=740&t=st=1711728845~exp=1711729445~hmac=8a31cb14bbd1a4eef800fc22ceb7263b07a8e4aa5b323f135ebcfe20131682ea', name: 'Name', distance: '300 KM', flagImage: 'https://cdn.pixabay.com/photo/2017/03/14/21/00/american-flag-2144392_1280.png',level: '27',));

      },
    );
  }
}
