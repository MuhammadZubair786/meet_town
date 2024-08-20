import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';

class SwipeExample extends StatefulWidget {
  const SwipeExample({super.key});

  @override
  State<SwipeExample> createState() => _SwipeExampleState();
}

class _SwipeExampleState extends State<SwipeExample> {

  int currentindex=0;

  List images=[
    'https://img.freepik.com/free-photo/happy-work-nude-sunbathing-nature-day_1303-3061.jpg?t=st=1719127356~exp=1719130956~hmac=3e96c4f3df32569be82c2d5a039e1eae8f806e0f485dd6b8fc3cdb12daf7dbf1&w=740',
    'https://img.freepik.com/premium-photo/young-beautiful-woman-is-walking-park-summer-girl-is-walking-spring-field-warm_372948-918.jpg?w=360',
    'https://img.freepik.com/free-photo/beautiful-woman-park-last-sunny-days_144627-16054.jpg?t=st=1719127363~exp=1719130963~hmac=d61ac411785789054469defa902202fb4e846e292b1a1318914e2e69c3659ccf&w=360',
    'https://img.freepik.com/free-photo/handsome-man-fixing-scarf_23-2148323500.jpg?t=st=1719127398~exp=1719130998~hmac=6b3a05e4305cb3b13ab181945aa08fc39eb33010ba7b06620cc6213ac681edd8&w=360',
    'https://img.freepik.com/free-photo/man-portrait-with-blue-lights-visual-effects_23-2149419476.jpg?t=st=1719127414~exp=1719131014~hmac=059d59b41204a8eebd3e7c6b5a27305d6e18e1ceb3b85ff967bb2cc67186e4e2&w=360','https://img.freepik.com/free-photo/attractive-brunette-girl-standing-blooming-garden-looking-forward-touching-hair_651396-3657.jpg?t=st=1719127367~exp=1719130967~hmac=058af47fef090a5dd2a1a0ab0a99fba28ec32a16a9a351710d0cf994a1c09078&w=360',
    'https://img.freepik.com/free-photo/african-american-guy-checkered-shirt-holding-ice-cream_23-2148205390.jpg?t=st=1719127396~exp=1719130996~hmac=2c399bb4e8a972eb919290e688924ee039fb563cfa00b0dbcc20f873596fac96&w=360',
    'https://img.freepik.com/free-photo/happy-work-nude-sunbathing-nature-day_1303-3061.jpg?t=st=1719127356~exp=1719130956~hmac=3e96c4f3df32569be82c2d5a039e1eae8f806e0f485dd6b8fc3cdb12daf7dbf1&w=740',
    'https://img.freepik.com/premium-photo/young-beautiful-woman-is-walking-park-summer-girl-is-walking-spring-field-warm_372948-918.jpg?w=360',
    'https://img.freepik.com/free-photo/beautiful-woman-park-last-sunny-days_144627-16054.jpg?t=st=1719127363~exp=1719130963~hmac=d61ac411785789054469defa902202fb4e846e292b1a1318914e2e69c3659ccf&w=360',

  ];

  PaletteGenerator? paletteGenerator;

  Color defaultcolor=Colors.white;

  @override
  void initState() {
    super.initState();
    getColor();
  }

  getColor()async{
    paletteGenerator =await PaletteGenerator.fromImageProvider(NetworkImage(images[currentindex]));
        
    if(paletteGenerator!.mutedColor!=null){
      defaultcolor=paletteGenerator!.mutedColor!.color;
    }
    else if(paletteGenerator!.vibrantColor!=null){
      defaultcolor=paletteGenerator!.vibrantColor!.color;
    }
    else if(paletteGenerator!.dominantColor!=null){
      defaultcolor=paletteGenerator!.dominantColor!.color;
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor:Colors.transparent,
      
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 650,
        child: CardSwiper(
          
          cardsCount: 8,

          cardBuilder: (context,index,x,y){
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(images[index],fit: BoxFit.cover,),
            );
          }, 
          
          
          // allowedSwipeDirection: AllowedSwipeDirection.only(right: true),
          
          // numberOfCardsDisplayed: 4,
          
          // isLoop: false,

          // backCardOffset: Offset(50,50),

          onSwipe: (prevoius,current,direction){

            currentindex=current!;
            getColor();
            if(direction==CardSwiperDirection.top){
              Fluttertoast.showToast(msg: '🔥 Send Request',backgroundColor: const Color.fromARGB(255, 84, 2, 2),fontSize: 28);
            }
            else if (direction==CardSwiperDirection.bottom){
              Fluttertoast.showToast(msg: '😖 Reject Request',backgroundColor: const Color.fromARGB(255, 38, 1, 1),fontSize: 28);
            }
            return true;

          },

          ),
      ),
    );
  }
}