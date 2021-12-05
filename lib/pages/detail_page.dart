import 'dart:ffi';

import 'package:bwa_cozy/models/space.dart';
import 'package:bwa_cozy/pages/error_page.dart';
import 'package:bwa_cozy/widgets/rating_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bwa_cozy/theme.dart';
import 'package:bwa_cozy/widgets/facility_item.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Space space;

  DetailPage(this.space);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    int index = -1;

    launchUrl(String url) async{
      if(await canLaunch(url)){
       await launch(url);
      }else{
        // throw(url);
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => ErrorPage(),
          ),
          );
      }
    }

    Future<Void> showConfirmation() async{
      return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Konfirmasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Apakah anda ingin menghubungi pemlik kos?'),
                ],
              ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Batal'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Hubungi'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    launchUrl('tel:${widget.space.phone}');
                  },
                ),
              ],
          );
        });
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Image.network(
            widget.space.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: 350,
            fit: BoxFit.cover,
            ),
            
            ListView(
              children: [
                SizedBox(height: 328,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height: 30,
                    ),
                    //Note : Title
                    Padding(
                      padding: EdgeInsets.symmetric(
                      horizontal: edge,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                          widget.space.name,
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                          ),
                          ),
                          SizedBox(height: 2,),
                          Text.rich(
                          TextSpan(text: '\$${widget.space.price}', 
                          style: purpleTextStyle.copyWith(
                            fontSize: 15,
                          ),
                        children: [
                          TextSpan(
                            text: ' /month',
                            style: greyTextStyle.copyWith(
                              fontSize: 15,
                        ),
                  ),
                ],
                ), 
              ),
                        ],
                        ),
                        Row(
                          children: [1,2,3,4,5].map((index){
                            return Container(
                              margin: EdgeInsets.only(
                                left: 2,
                              ),
                              child: RatingItem(
                                index: index,
                                rating: widget.space.rating,
                                ),
                            );
                          }).toList(),
                        )
                      ],),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //Note : Main Facilities
                       Padding(padding: EdgeInsets.only(left: edge),
                        child: Text(
                          'Main Facilities',
                          style: regularTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(padding: EdgeInsets.symmetric(
                          horizontal: edge,
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                        children: [
                        FacilityItem(
                          name: 'Kitchen',
                          imageUrl: 'assets/icon_kitchen.png',
                          total: widget.space.numberOfKitchens,
                        ),  
                        FacilityItem(
                          name: 'Bedroom',
                          imageUrl: 'assets/icon_bedroom.png',
                          total: widget.space.numberOfBedrooms,
                        ),  
                        FacilityItem(
                          name: 'Big lemari',
                          imageUrl: 'assets/icon_cupboard.png',
                          total: widget.space.numberOfCupboards,
                        ),  
                        ],
                        ),
                        ),
                        SizedBox(height: 30,
                        ),
                        //Note: Photos
                        Padding(padding: EdgeInsets.only(left: edge),
                        child: Text(
                          'Photos',
                          style: regularTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 88,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: 
                              widget.space.photos.map((item){
                                index++;
                                return Container( 
                                  margin: EdgeInsets.only(
                                  right: edge,
                                  left: index == 0 ? edge : 0
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      item,
                                      width: 110,
                                      height: 88,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                         // Note : Location
                        Padding(padding: EdgeInsets.only(left: edge),
                          child: Text(
                          'Location',
                          style: regularTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: edge,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.space.address}\n${widget.space.city}',
                              style: greyTextStyle,
                              ),
                              InkWell(
                                onTap: (){
                                  launchUrl(widget.space.mapUrl);
                                },
                                child: Image.asset('assets/btn_map.png',
                                width: 40,
                                ),
                              ),  
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: edge,
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width - (2 * edge),
                          
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: (){
                              showConfirmation();
                            },
                            color: purpleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                              ),
                            child: Text(
                              'Book Now',
                              style: whiteTextStyle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          ),
                      ],
                  ),
                ),
              ],
            ),
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: edge,
                vertical: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/btn_back.png',
                  width: 40,
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      isClicked = !isClicked;
                    });
                  },
                  child: Image.asset(
                   isClicked
                    ? 'assets/btn_wishlist_active.png' 
                    : 'assets/btn_wishlist.png',
                  width: 40,
                  ),
                ),
              ],),
            ),
          ],
        ),
      ),
    );
  }
}