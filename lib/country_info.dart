import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'home.dart';
import 'counter.dart';
import 'constrainsts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Info_country extends StatefulWidget {
  @override
  _Info_countryState createState() => _Info_countryState();
}

class _Info_countryState extends State<Info_country>
    with TickerProviderStateMixin {
  List countrydata;

  Future<void> _countrydata() async {
    final url = 'https://disease.sh/v3/covid-19/countries/$display';
    var response = await http.get(Uri.https(
      "disease.sh",
      "v3/covid-19/countries/$display",
    ));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        countrydata = [data];
        // print(countrydata);
      });
    }
  }

  List taa;

  var formatter = NumberFormat('#,##,000');

  List filtered = [];
  List<double> vaccinated = [];

  Future<void> vaccinatedno() async {
    // var response = await http.get(Uri.https("disease .sh",
    //     "v3/covid-19/vaccine/coverage/countries/$display?lastdays=10&fullData=false"));

    // var data = json.decode(response.body);
    // print(data);

    // if (response.statusCode == 200) {
    //   // vaccinated = [
    //   //   {
    //   //     {"date": data["timeline"][1]}
    //   //   }
    //   // ];
    //   print(data["timeline"]["5/26/21"]);
    // }

    final url =
        'https://disease.sh/v3/covid-19/vaccine/coverage/countries/kw?lastdays=30&fullData=false';
    var response = await http.get(
      Uri.http("ix.cnn.io",
          "data/novel-coronavirus-2019-ncov/vaccines-world/vaccine-owid-history.min.json"),
    );

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        // print(data[0]["name"]);

        // data
        //     .where((element) => element["name"] == "India")
        //     .map((e) => print(e));
        List<dynamic> data = map["data"];
        print(country_name);
        data.forEach((element) {
          if (element["name"] == country_name) {
            element["data"].forEach((e) {
              vaccinated.add(double.tryParse("${e["dailyDosesAvg"]}"));
              print({e["dailyDosesAvg"]});
            });
            // print(vaccinated);
            for (int i = 1; i < 11; i++) {
              filtered.add({
                "date": element["data"][element["data"].length - i]["date"],
                "vaccine": element["data"][element["data"].length - i]
                    ["dailyDosesAvg"]
              });
            }

          }
        });
      });
      print(filtered);
   
    }
  }

  Future<void> _getcountrydaa() async {
    final url = 'https://corona-api.com/countries/$display';
    var response =
        await http.get(Uri.https("corona-api.com", "countries/$display"));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        taa = [data];
        for (int i = 1; i < 11; i++) {
          new_infected.add(
            {
              "date": taa[0]["data"]["timeline"][i]["date"],
              "cases": taa[0]["data"]["timeline"][i - 1]["new_confirmed"],
            },
          );
        }
        // new_infected = [
        //   {
        //     "date": taa[0]["data"]["timeline"][1]["date"],
        //     "cases": taa[0]["data"]["timeline"][0]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][2]["date"],
        //     "cases": taa[0]["data"]["timeline"][1]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][3]["date"],
        //     "cases": taa[0]["data"]["timeline"][2]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][4]["date"],
        //     "cases": taa[0]["data"]["timeline"][3]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][5]["date"],
        //     "cases": taa[0]["data"]["timeline"][4]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][6]["date"],
        //     "cases": taa[0]["data"]["timeline"][5]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][7]["date"],
        //     "cases": taa[0]["data"]["timeline"][6]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][8]["date"],
        //     "cases": taa[0]["data"]["timeline"][7]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][9]["date"],
        //     "cases": taa[0]["data"]["timeline"][8]["new_confirmed"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][10]["date"],
        //     "cases": taa[0]["data"]["timeline"][9]["new_confirmed"],
        //   },
        // ];
        for (int i = 1; i < 11; i++) {
          new_deaths.add(
            {
              "date": taa[0]["data"]["timeline"][i]["date"],
              "cases": taa[0]["data"]["timeline"][i - 1]["new_deaths"],
            },
          );
        }
        // new_deaths = [
        //   {
        //     "date": taa[0]["data"]["timeline"][1]["date"],
        //     "cases": taa[0]["data"]["timeline"][0]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][2]["date"],
        //     "cases": taa[0]["data"]["timeline"][1]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][3]["date"],
        //     "cases": taa[0]["data"]["timeline"][2]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][4]["date"],
        //     "cases": taa[0]["data"]["timeline"][3]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][5]["date"],
        //     "cases": taa[0]["data"]["timeline"][4]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][6]["date"],
        //     "cases": taa[0]["data"]["timeline"][5]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][7]["date"],
        //     "cases": taa[0]["data"]["timeline"][6]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][8]["date"],
        //     "cases": taa[0]["data"]["timeline"][7]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][9]["date"],
        //     "cases": taa[0]["data"]["timeline"][8]["new_deaths"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][10]["date"],
        //     "cases": taa[0]["data"]["timeline"][9]["new_deaths"],
        //   },
        // ];
        for (int i = 1; i < 11; i++) {
          new_recovered.add(
            {
              "date": taa[0]["data"]["timeline"][i]["date"],
              "cases": taa[0]["data"]["timeline"][i - 1]["new_recovered"],
            },
          );
        }
        // new_recovered = [
        //   {
        //     "date": taa[0]["data"]["timeline"][1]["date"],
        //     "cases": taa[0]["data"]["timeline"][0]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][2]["date"],
        //     "cases": taa[0]["data"]["timeline"][1]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][3]["date"],
        //     "cases": taa[0]["data"]["timeline"][2]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][4]["date"],
        //     "cases": taa[0]["data"]["timeline"][3]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][5]["date"],
        //     "cases": taa[0]["data"]["timeline"][4]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][6]["date"],
        //     "cases": taa[0]["data"]["timeline"][5]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][7]["date"],
        //     "cases": taa[0]["data"]["timeline"][6]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][8]["date"],
        //     "cases": taa[0]["data"]["timeline"][7]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][9]["date"],
        //     "cases": taa[0]["data"]["timeline"][8]["new_recovered"],
        //   },
        //   {
        //     "date": taa[0]["data"]["timeline"][10]["date"],
        //     "cases": taa[0]["data"]["timeline"][9]["new_recovered"],
        //   },
        // ];
        // print(new_recovered);
      });
    }
  }

  // List<Avengers> avengers;
  // List<Avengers> selectedAvengers;

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  bool sort;
  List new_infected = [];
  List new_deaths = [];
  List new_recovered = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vaccinatedno();
    _countrydata();
    _getcountrydaa();
    _controller = new TabController(length: 4, vsync: this);
    _initGoogleMobileAds();
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-8451070411450683/2616366658",
      request: AdRequest(keywords: ["Insurance"]),
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
    // sort = false;
    // selectedAvengers = [];
    // avengers = Avengers.getAvengers();
  }

  // onSortColum(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     if (ascending) {
  //       avengers.sort((a, b) => a.name.compareTo(b.name));
  //     } else {
  //       avengers.sort((a, b) => b.name.compareTo(a.name));
  //     }
  //   }
  // }
  TabController _controller;

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //  statusBarColor: Color(4294967295),
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Stack(
        children: [
          Container(
              color: Colors.teal,
              height: double.infinity,
              width: double.infinity,
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                countrydata == null
                    ? Container()
                    : ListView.builder(
                        itemCount: countrydata == null ? 0 : countrydata.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://disease.sh/assets/img/flags/$display.png"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${countrydata[i]['country']}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredokaOne(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          );
                        }),
                SizedBox(
                  height: 0,
                ),
                countrydata == null
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : ListView.builder(
                        itemCount: countrydata == null ? 0 : countrydata.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${formatter.format(countrydata[i]['cases'])}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredokaOne(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Icon(
                                Icons.arrow_upward,
                                size: 35,
                                color: Colors.white,
                              )
                            ],
                          );
                        })
              ])),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color(4278656558)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _isBannerAdReady == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: _bannerAd.size.width.toDouble(),
                                height: _bannerAd.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Today's Cases",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.fredokaOne(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 23),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Center(
                        child: taa == null
                            ? Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: CircularProgressIndicator())
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: countrydata == null
                                    ? 0
                                    : countrydata.length,
                                itemBuilder: (ctx, i) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Counter(
                                              color: kInfectedColor,
                                              number:
                                                  "${formatter.format(countrydata[i]["todayCases"])}",
                                              title: "Infected",
                                            ),
                                            Counter(
                                              color: kDeathColor,
                                              number:
                                                  "${formatter.format(countrydata[i]["todayDeaths"])}"
                                                      .toString(),
                                              title: "Deaths",
                                            ),
                                            Counter(
                                              color: kRecovercolor,
                                              number:
                                                  "${formatter.format(countrydata[i]["todayRecovered"])}",
                                              title: "Recovered",
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // Padding(
                                      //     padding: EdgeInsets.only(left: 0, right: 0),
                                      //     child: Text(
                                      //       "Previous Cases",
                                      //       textAlign: TextAlign.start,
                                      //       style: GoogleFonts.fredokaOne(
                                      //           color: Colors.teal,
                                      //           fontWeight: FontWeight.w500,
                                      //           fontSize: 25),
                                      //     )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Previous Cases",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.fredokaOne(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 23),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 10),
                                            child: TabBar(
                                                indicatorSize:
                                                    TabBarIndicatorSize.label,
                                                labelPadding: EdgeInsets.all(0),
                                                indicatorPadding:
                                                    EdgeInsets.all(0),
                                                indicatorColor: Colors.teal,
                                                isScrollable: false,
                                                controller: _controller,
                                                tabs: [
                                                  Tab(
                                                      icon: Text(
                                                    "Infected",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: kInfectedColor),
                                                  )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Tab(
                                                        icon: Text(
                                                      "Death",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: kDeathColor),
                                                    )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Tab(
                                                        icon: Text(
                                                      "Recovered",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: kRecovercolor),
                                                    )),
                                                  ),
                                                  Tab(
                                                      icon: Text(
                                                    "Vaccinated",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.lightBlue),
                                                  ))
                                                ]),
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Container(
                                            height: 720,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20),
                                              child: TabBarView(
                                                  controller: _controller,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        taa.length == 0
                                                            ? Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/nodata.png",
                                                                    height: 150,
                                                                  ),
                                                                  Text(
                                                                      "NO DATA ....",
                                                                      style: GoogleFonts.fredokaOne(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.black))
                                                                ],
                                                              )
                                                            : ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: 1,
                                                                itemBuilder:
                                                                    (ctx, i) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            100,
                                                                        width: double
                                                                            .infinity,
                                                                        child: new SfSparkAreaChart(
                                                                            borderColor: kInfectedColor,
                                                                            borderWidth: 1,
                                                                            axisLineColor: Colors.transparent,
                                                                            color: kInfectedColor.withOpacity(0.4),
                                                                            //Enable the trackball
                                                                            trackball: SparkChartTrackball(
                                                                              activationMode: SparkChartActivationMode.tap,
                                                                              tooltipFormatter: (TooltipFormatterDetails w) {
                                                                                return formatter.format(w.y);
                                                                              },
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            //Enable marker
                                                                            marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.none),
                                                                            //Enable data label
                                                                            labelDisplayMode: SparkChartLabelDisplayMode.none,
                                                                            data: taa[i]["data"]["timeline"].map<double>((e) {
                                                                              return double.parse("${e["new_confirmed"]}");
                                                                            }).toList()),
                                                                      ));
                                                                }),
                                                        Container(
                                                          height: 600,
                                                          child: DataTable(
                                                              columns: [
                                                                DataColumn(
                                                                    label: Text(
                                                                  'Date',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                                DataColumn(
                                                                    label: Text(
                                                                        '')),
                                                                DataColumn(
                                                                  label: Expanded(
                                                                      child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(top: 0, right: 0),
                                                                              child: Text(
                                                                                'Infected',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: kInfectedColor,
                                                                                ),
                                                                              )))),
                                                                  // Text(
                                                                  //   'No. of cases',
                                                                  //   style: TextStyle(
                                                                  //     fontSize: 16,
                                                                  //     color: kInfectedColor,
                                                                  //   ),
                                                                  // )
                                                                ),
                                                              ],
                                                              rows: new_infected
                                                                  .map<DataRow>(
                                                                      (e) {
                                                                return DataRow(
                                                                    cells: <
                                                                        DataCell>[
                                                                      DataCell(
                                                                          Text(
                                                                        "${e["date"]}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                      DataCell(
                                                                          Text(
                                                                              "")),
                                                                      DataCell(
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          e["cases"] == 0
                                                                              ? "${formatter.format(0)}"
                                                                              : "${formatter.format(e["cases"])}",
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                kInfectedColor,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                    ]);
                                                              }).toList()),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        taa.length == 0
                                                            ? Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/nodata.png",
                                                                    height: 150,
                                                                  ),
                                                                  Text(
                                                                      "NO DATA ....",
                                                                      style: GoogleFonts.fredokaOne(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.black))
                                                                ],
                                                              )
                                                            : ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: 1,
                                                                itemBuilder:
                                                                    (ctx, i) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            100,
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            new SfSparkAreaChart(
                                                                          borderColor:
                                                                              kDeathColor,
                                                                          borderWidth:
                                                                              1,
                                                                          axisLineColor:
                                                                              Colors.transparent,

                                                                          color:
                                                                              kDeathColor.withOpacity(0.4),
                                                                          //Enable the trackball
                                                                          trackball: SparkChartTrackball(
                                                                              tooltipFormatter: (TooltipFormatterDetails w) {
                                                                                return formatter.format(w.y);
                                                                              },
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              activationMode: SparkChartActivationMode.tap),
                                                                          //Enable marker
                                                                          marker:
                                                                              SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.none),
                                                                          //Enable data label
                                                                          labelDisplayMode:
                                                                              SparkChartLabelDisplayMode.none,
                                                                          data:
                                                                              taa[i]["data"]["timeline"].map<double>((e) {
                                                                            return double.parse("${e["new_deaths"]}");
                                                                          }).toList(),
                                                                        ),
                                                                      ));
                                                                }),
                                                        Container(
                                                          height: 600,
                                                          child: DataTable(
                                                              columns: [
                                                                DataColumn(
                                                                    label: Text(
                                                                  'Date',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                                DataColumn(
                                                                    label: Text(
                                                                        '')),
                                                                DataColumn(
                                                                  label: Expanded(
                                                                      child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(top: 0, right: 0),
                                                                              child: Text(
                                                                                'Deaths',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: kDeathColor,
                                                                                ),
                                                                              )))),
                                                                  // Text(
                                                                  //   'No. of cases',
                                                                  //   style: TextStyle(
                                                                  //     fontSize: 16,
                                                                  //     color: kInfectedColor,
                                                                  //   ),
                                                                  // )
                                                                ),
                                                              ],
                                                              rows: new_deaths
                                                                  .map<DataRow>(
                                                                      (e) {
                                                                return DataRow(
                                                                    cells: <
                                                                        DataCell>[
                                                                      DataCell(Text(
                                                                          "${e["date"]}",
                                                                          style:
                                                                              TextStyle(color: Colors.white))),
                                                                      DataCell(
                                                                          Text(
                                                                              "")),
                                                                      DataCell(
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          e["cases"] == ""
                                                                              ? "${formatter.format(0)}"
                                                                              : "${formatter.format(e["cases"])}",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                kDeathColor,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                    ]);
                                                              }).toList()),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        taa.length == 0
                                                            ? Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/nodata.png",
                                                                    height: 150,
                                                                  ),
                                                                  Text(
                                                                      "NO DATA ....",
                                                                      style: GoogleFonts.fredokaOne(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.black))
                                                                ],
                                                              )
                                                            : ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: 1,
                                                                itemBuilder:
                                                                    (ctx, i) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            100,
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            new SfSparkAreaChart(
                                                                          borderColor:
                                                                              kRecovercolor,
                                                                          borderWidth:
                                                                              1,
                                                                          axisLineColor:
                                                                              Colors.transparent,

                                                                          color:
                                                                              kRecovercolor.withOpacity(0.4),
                                                                          //Enable the trackball
                                                                          trackball: SparkChartTrackball(
                                                                              tooltipFormatter: (TooltipFormatterDetails w) {
                                                                                return formatter.format(w.y);
                                                                              },
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              activationMode: SparkChartActivationMode.tap),
                                                                          //Enable marker
                                                                          marker:
                                                                              SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.none),
                                                                          //Enable data label
                                                                          labelDisplayMode:
                                                                              SparkChartLabelDisplayMode.none,
                                                                          data:
                                                                              taa[i]["data"]["timeline"].map<double>((e) {
                                                                            return double.parse("${e["new_recovered"]}");
                                                                          }).toList(),
                                                                        ),
                                                                      ));
                                                                }),
                                                        Container(
                                                          height: 600,
                                                          child: DataTable(
                                                              columns: [
                                                                DataColumn(
                                                                    label: Text(
                                                                        'Date',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                DataColumn(
                                                                    label: Text(
                                                                        '')),
                                                                DataColumn(
                                                                  label: Expanded(
                                                                      child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(top: 0, right: 0),
                                                                              child: Text(
                                                                                'Recovered',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: kRecovercolor,
                                                                                ),
                                                                              )))),
                                                                  // Text(
                                                                  //   'No. of cases',
                                                                  //   style: TextStyle(
                                                                  //     fontSize: 16,
                                                                  //     color: kInfectedColor,
                                                                  //   ),
                                                                  // )
                                                                ),
                                                              ],
                                                              rows: new_recovered
                                                                  .map<DataRow>(
                                                                      (e) {
                                                                return DataRow(
                                                                    cells: <
                                                                        DataCell>[
                                                                      DataCell(Text(
                                                                          "${e["date"]}",
                                                                          style:
                                                                              TextStyle(color: Colors.white))),
                                                                      DataCell(
                                                                          Text(
                                                                              "")),
                                                                      DataCell(
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          e["cases"] == ""
                                                                              ? "${formatter.format(0)}"
                                                                              : "${formatter.format(e["cases"])}",
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                kRecovercolor,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                    ]);
                                                              }).toList()),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        vaccinated.length == 0
                                                            ? Center(
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                    Center(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 13.0),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Lottie.asset(
                                                                                "assets/load.json",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Text("No Data...",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.fredokaOne(fontSize: 30, color: Colors.white)),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]))
                                                            : Column(children: [
                                                                ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            1,
                                                                        itemBuilder:
                                                                            (ctx,
                                                                                i) {
                                                                          return Padding(
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Container(
                                                                                height: 100,
                                                                                width: double.infinity,
                                                                                child: new SfSparkAreaChart(
                                                                                    borderColor: Colors.lightBlue,
                                                                                    borderWidth: 1,
                                                                                    axisLineColor: Colors.transparent,
                                                                                    color: Colors.lightBlue.withOpacity(0.4),
                                                                                    //Enable the trackball
                                                                                    trackball: SparkChartTrackball(
                                                                                        tooltipFormatter: (TooltipFormatterDetails w) {
                                                                                          return formatter.format(w.y);
                                                                                        },
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        activationMode: SparkChartActivationMode.tap),
                                                                                    //Enable marker
                                                                                    marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.none),
                                                                                    //Enable data label
                                                                                    labelDisplayMode: SparkChartLabelDisplayMode.none,
                                                                                    data:
                                                                                        // filtered.map<double>((e) {
                                                                                        //   return double.parse("${e["vaccine"]}");
                                                                                        // }).toList()
                                                                                        vaccinated.reversed.toList()),
                                                                              ));
                                                                        }),
                                                                Container(
                                                                  height: 600,
                                                                  child: DataTable(
                                                                      columns: [
                                                                        DataColumn(
                                                                            label:
                                                                                Text(
                                                                          'Date',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                        DataColumn(
                                                                            label:
                                                                                Text('')),
                                                                        DataColumn(
                                                                          label: Expanded(
                                                                              child: SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Padding(
                                                                                      padding: const EdgeInsets.only(top: 0, right: 0),
                                                                                      child: Text(
                                                                                        'Vaccinated',
                                                                                        style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          color: Colors.lightBlue,
                                                                                        ),
                                                                                      )))),
                                                                          // Text(
                                                                          //   'No. of cases',
                                                                          //   style: TextStyle(
                                                                          //     fontSize: 16,
                                                                          //     color: kInfectedColor,
                                                                          //   ),
                                                                          // )
                                                                        ),
                                                                      ],
                                                                      rows: filtered.map<DataRow>((e) {
                                                                        return DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text("${e["date"]}", style: TextStyle(color: Colors.white))),
                                                                              DataCell(Text("")),
                                                                              DataCell(Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  e["vaccine"] != "" ? "${e["vaccine"]}" : "0",
                                                                                  textAlign: TextAlign.end,
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    color: Colors.lightBlue,
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                            ]);
                                                                      }).toList()),
                                                                )
                                                              ]),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class Avengers {
//   String name;
//   String weapon;

//   Avengers({this.name, this.weapon});

//   static List<Avengers> getAvengers() {
//     return <Avengers>[
//       Avengers(name: "Captain America", weapon: "Shield"),
//       Avengers(name: "Thor", weapon: "Mjolnir"),
//       Avengers(name: "Spiderman", weapon: "Web Shooters"),
//       Avengers(name: "Doctor Strange ", weapon: "Eye Of Agamotto"),
//     ];
//   }
// }
