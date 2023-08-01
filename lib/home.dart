import 'package:covicheck/constrainsts.dart';
import 'package:covicheck/country_info.dart';
import 'package:covicheck/prevent.dart';
import 'package:covicheck/search.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:native_updater/native_updater.dart';
import 'counter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'country_info.dart';
import 'data.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List worldwide = [];
  Future<void> _getcountrydata() async {
    String url = 'https://disease.sh/v3/covid-19/all';
    var response = await http.get(Uri.https(
      "disease.sh",
      "v3/covid-19/all",
    ));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        worldwide = [data];
      });
    }
  }

  List options = List();
  Future<void> getoptions() async {
    final url = 'https://disease.sh/v3/covid-19/countries';
    var response = await http.get(Uri.https(
      "disease.sh",
      "v3/covid-19/countries",
    ));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        options = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getcountrydata();
    getoptions();
    // getGraph();
    native_updater();

    _func = fetchSummary();
    controller.addListener(onScroll);
    super.initState();
    _initGoogleMobileAds();
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-8451070411450683/2616366658",
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  native_updater() {
    NativeUpdater.displayUpdateAlert(
      context,
      forceUpdate: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    _bannerAd.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  final controller = ScrollController();
  double offset = 0;
  bool sortAscending = false;
  Future<List<Summary>> _func;

  sort(List list) {
    list.sort((a, b) => b.totalConfirmed.compareTo(a.totalConfirmed));
    if (!sortAscending) {
      list = list.reversed.toList();
    }
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    print("==>" + "${(MediaQuery.of(context).size.width - 20) / 2}");

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(4278656558),
        body: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  brightness: Brightness.dark,
                  leadingWidth: 0,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  stretch: false,
                  toolbarHeight: 180,
                  expandedHeight: 190,
                  title: Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightGreen[200]),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 30, top: 20),
                                    child: Text(
                                      "  3 Symtopms of \n  COVID-19 ",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Prevent()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Container(
                                        width: 120,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(4278656558)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Learn More",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: Image.asset("assets/images/wash_hands.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color:
                              // Color(4293719283),
                              Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 0, top: 0),
                              child: Container(
                                height: 306,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                      Stack(alignment: Alignment.bottomCenter,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            height: 200,
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
                                            child: FlutterMap(
                                              options: MapOptions(
                                                maxZoom: 3,
                                                onTap: (v) {
                                                  print(v);
                                                },
                                                enableMultiFingerGestureRace:
                                                    true,
                                                rotationWinGestures:
                                                    MultiFingerGesture.none,
                                                center: LatLng(20.80746, 2.7),
                                                zoom: 1,
                                              ),
                                              layers: [
                                                TileLayerOptions(
                                                    urlTemplate:
                                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                    subdomains: [
                                                      'a',
                                                      'b',
                                                      'c'
                                                    ]),
                                                CircleLayerOptions(
                                                    circles:
                                                        List<CircleMarker>.from(
                                                            options.map((e) {
                                                  return CircleMarker(
                                                    //radius marker
                                                    point: LatLng(
                                                        double.parse(
                                                            "${e["countryInfo"]["lat"]}"),
                                                        double.parse(
                                                            "${e["countryInfo"]["long"]}")),
                                                    color: kInfectedColor
                                                        .withOpacity(0.2),
                                                    borderStrokeWidth: 2.0,

                                                    radius:
                                                        sqrt(e["cases"]) / 190,
                                                    borderColor: kInfectedColor,
                                                  );
                                                })).toList()),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: worldwide.length == 0
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Counter(
                                                        color: kInfectedColor,
                                                        fontsize: 20,
                                                        subFontSize: 13,
                                                        number:
                                                            "${formatter.format(worldwide[0]["todayCases"])}" ??
                                                                0,
                                                        title: "Infected",
                                                      ),
                                                      Counter(
                                                        color: kDeathColor,
                                                        fontsize: 20,
                                                        subFontSize: 13,
                                                        number:
                                                            "${formatter.format(worldwide[0]["todayDeaths"])}" ??
                                                                0,
                                                        title: "Deaths",
                                                      ),
                                                      Counter(
                                                        color: kRecovercolor,
                                                        fontsize: 20,
                                                        subFontSize: 13,
                                                        number:
                                                            "${formatter.format(worldwide[0]["todayRecovered"])}" ??
                                                                0,
                                                        title: "Recovered",
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ]),
                                ),
                              )
                              // SfMaps(
                              //   layers: [
                              //     MapShapeLayer(
                              //       source: MapShapeSource.network(
                              //           "https://raw.githubusercontent.com/syncfusion/flutter-examples/master/assets/world_map.json"),
                              //       sublayers: [
                              //         MapCircleLayer(
                              //             // circles: List<MapCircle>.generate(
                              //             //   circles.length,
                              //             //   (int index) {
                              //             //     return MapCircle(
                              //             //       center: circles[index],
                              //             //     );
                              //             //   },
                              //             // ).toSet(),
                              //             circles: List<MapCircle>.from(
                              //                 options.map((e) {
                              //           return MapCircle(
                              //               radius: sqrt(e["cases"] * 8),
                              //               color: Colors.green.withOpacity(.2),
                              //               center: MapLatLng(
                              //                 double.parse(
                              //                     "${e["countryInfo"]["lat"]}"),
                              //                 double.parse(
                              //                     "${e["countryInfo"]["long"]}"),
                              //               ));
                              //         })).toSet()),
                              //       ],
                              //     ),
                              //   ],
                              // )

                              // worldwide == null
                              //     ? Container()
                              //     : Center(
                              //         child: ListView.builder(
                              //           physics: NeverScrollableScrollPhysics(),
                              //           shrinkWrap: true,
                              //           itemCount: worldwide.length,
                              //           itemBuilder: (ctx, i) {
                              //             return Padding(
                              //               padding: const EdgeInsets.only(right: 20),
                              //               child: Container(
                              //                 alignment: Alignment.centerRight,
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.center,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.center,
                              //                   children: [
                              //                     Counter(
                              //                       color: kInfectedColor,
                              //                       number:
                              //                           "${worldwide[i]['todayCases']}",
                              //                       title: "Infected",
                              //                     ),
                              //                     SizedBox(
                              //                       height: 10,
                              //                     ),
                              //                     Counter(
                              //                       color: kDeathColor,
                              //                       number:
                              //                           "${worldwide[i]['todayDeaths']}",
                              //                       title: "Deaths",
                              //                     ),
                              //                     SizedBox(
                              //                       height: 10,
                              //                     ),
                              //                     Counter(
                              //                       color: kRecovercolor,
                              //                       number:
                              //                           "${worldwide[i]['todayRecovered']}",
                              //                       title: "Recovered",
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //         ),
                              //       ),
                              )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 10, right: 10),
                  //     height: 50,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(17),
                  //       border: Border.all(
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     child: Row(
                  //       children: <Widget>[
                  //         SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  //         SizedBox(width: 20),
                  //         Expanded(
                  //           child: Container(
                  //             width: 200,
                  //             child: DropdownButtonHideUnderline(
                  //               child: ButtonTheme(
                  //                 alignedDropdown: true,
                  //                 child: DropdownButton(
                  //                   hint: Text(
                  //                     "Choose A Country",
                  //                     textAlign: TextAlign.start,
                  //                     style: GoogleFonts.poppins(
                  //                         color: Colors.black,
                  //                         fontSize: 20,
                  //                         fontWeight: FontWeight.w400),
                  //                   ),
                  //                   isExpanded: true,
                  //                   items: options.map((e) {
                  //                     return new DropdownMenuItem(
                  //                       child: Text(
                  //                         e["country"],
                  //                         style: TextStyle(fontSize: 20),
                  //                       ),
                  //                       value: e["countryInfo"]["iso2"]
                  //                           .toString()
                  //                           .toLowerCase(),
                  //                     );
                  //                   }).toList(),
                  //                   onChanged: (String value) {
                  //                     setState(() {
                  //                       display = value;
                  //                     });
                  //                     Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                             builder: (context) => Info_country()));
                  //                     print(value);
                  //                     _getcountrydata();
                  //                   },
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Hero(
                    tag: "1",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MainPage()));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Color(4281304013),
                                size: 28,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  width: 200,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      "Search For A Country",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isBannerAdReady == true
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: _bannerAd.size.width.toDouble(),
                            height: _bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Top Countries",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.fredokaOne(
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        )),
                  ),
                  DetailsScreen()
                ]))
              ],
            ),
          ],
        ));
  }
}

String display;
String country_name;
