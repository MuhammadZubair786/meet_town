import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LocationCart extends StatelessWidget {
  String userImage, name, distance, flagImage,level;
   LocationCart({super.key,required this.userImage, required this.name,required this.distance,required this.flagImage,required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                    userImage,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 6.5,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 40,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 40,
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$name , $level'),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 110,
            left: 80,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(195, 158, 158, 158),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  distance,
                  style: TextStyle(color: Colors.white,fontSize: 10),
                )),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: CachedNetworkImage(
              imageUrl:
                  flagImage,
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                width: 30,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 10,
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 10,
                child: Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
