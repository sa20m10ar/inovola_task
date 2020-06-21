import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inovola_task/src/models/trip_model.dart';
import 'package:inovola_task/src/services/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TripDetails extends StatefulWidget {
  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  Api api = Api();

  Trip tripData;
  Future<Trip> fetchTripData() async {
    Response response = await api.getTripData();
    Trip tripData = Trip.fromJson(response.data);
    return tripData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(),
        body: FutureBuilder(
            future: fetchTripData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                initializeDateFormatting();
                var date = DateFormat.MMMMEEEEd('ar_DZ')
                    .add_jm()
                    .format(snapshot.data.date);
                final String mixedText = snapshot.data.occasionDetail;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ImgCarousel(snapshot: snapshot.data,),
                      Container(
                        margin: EdgeInsets.only(left: 15,right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${snapshot.data.interest} # ',
                              style: GoogleFonts.cairo(),
                            ),
                            Text(
                              snapshot.data.title,
                              style: GoogleFonts.cairo(
                                  textStyle: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  date.toString(),
                                  style: GoogleFonts.cairo(),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Image.asset(
                                  'assets/images/cal.png',
                                  width: 25,
                                  height: 25,
                                  color: Colors.grey[600],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  snapshot.data.address,
                                  style: GoogleFonts.cairo(),
                                ),
                                Image.asset(
                                  'assets/images/pin.png',
                                  width: 25,
                                  height: 25,
                                  color: Colors.grey[600],
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey[500],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  snapshot.data.trainerName,
                                  style: GoogleFonts.cairo(
                                      textStyle:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/img.jpg'),
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                            Text(
                              snapshot.data.trainerInfo,
                              style: GoogleFonts.cairo(),
                            ),
                            Divider(
                              color: Colors.grey[500],
                            ),
                            Text('عن الرحلة',
                                style: GoogleFonts.cairo(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold))),
                            Text.rich(
                              TextSpan(text: mixedText, style: GoogleFonts.cairo()),
                              textAlign: TextAlign.right,
                            ),
                            Divider(
                              color: Colors.grey[500],
                            ),
                            Text('تكلفة الدورة',
                                style: GoogleFonts.cairo(
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('SAR ${snapshot.data.price}',
                                    style: GoogleFonts.cairo()),
                                Text('الحجز العادى',
                                    style: GoogleFonts.cairo(
                                        )),

                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                print('${snapshot.error}');
                return Center(child: Text('${snapshot.error}'));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}


class ImgCarousel extends StatelessWidget {
  final Trip snapshot;
  const ImgCarousel({
    Key key, this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 280,
          child: Carousel(
            images: [
              NetworkImage(snapshot.img[1]),
              NetworkImage(snapshot.img[0]),
              NetworkImage(snapshot.img[2]),
              NetworkImage(snapshot.img[3])
            ],
            dotIncreaseSize: 2,
            dotBgColor: Colors.transparent,
            autoplay: false,
            dotColor: Colors.grey[300],
            dotIncreasedColor: Colors.white,
            dotPosition: DotPosition.bottomLeft,
          ),
        ),
        Container(
          // margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset(
                    'assets/images/star.png',
                    width: 35,
                    height: 35,
                    color: Colors.white,
                  ),
                  Image.asset(
                    'assets/images/share.png',
                    width: 35,
                    height: 35,
                    color: Colors.white,
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.purple,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text('قم بالحجز الآن',
            style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
