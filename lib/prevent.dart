import 'package:flutter/material.dart';
import 'constrainsts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Prevent());
}

class Prevent extends StatefulWidget {
  @override
  _PreventState createState() => _PreventState();
}

class _PreventState extends State<Prevent> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    //  TODO: implement initState
    super.initState();
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
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //  statusBarColor: Color(4294967295),
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        backgroundColor: Color(4278656558),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.dark,
              leading: Container(
                width: 0,
                height: 0,
              ),
              primary: true,
              leadingWidth: 0,
              pinned: false,
              backgroundColor: Colors.transparent,
              stretch: false,
              toolbarHeight: 300,
              expandedHeight: 300,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.teal),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: Image.asset("assets/images/virus.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 200, top: 30),
                        child: Image.asset("assets/images/virus.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 100, top: 200),
                        child: Image.asset("assets/images/virus.png"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 35, left: 0),
                            child: Image.asset("assets/images/doctor.png",
                                height: 250),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 110),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: RichText(
                                text: TextSpan(
                                  text: 'All you need to do \nis',
                                  style: GoogleFonts.fredokaOne(
                                      color: Colors.white,
                                      fontSize: 29,
                                      fontWeight: FontWeight.w300),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' stay at home',
                                        style: GoogleFonts.fredokaOne(
                                            color: Color(4278656558),
                                            fontSize: 29,
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Symptoms",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.fredokaOne(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 23),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SymptomCard(
                            image: "assets/images/headache.png",
                            title: "Headache",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SymptomCard(
                            image: "assets/images/caugh.png",
                            title: "Caugh",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SymptomCard(
                            image: "assets/images/fever.png",
                            title: "Fever",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Precautions",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.fredokaOne(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 23),
                    ),
                    SizedBox(height: 20),
                    PreventCard(
                      text:
                          "Wearing Masks prevents our droplets from reaching others.",
                      image: "assets/images/wear_mask.png",
                      title: "Wear face mask",
                    ),
                    PreventCard(
                      text:
                          "Washing hands can keep you healthy and prevent the spread ",
                      image: "assets/images/wash_hands.png",
                      title: "Wash your hands",
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ]))
          ],
        ));
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                height: 156,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: 80,
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 15, color: Colors.white),
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
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.teal.withOpacity(0.3),
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
