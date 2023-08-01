import 'dart:convert';
import 'dart:io';
import 'package:covicheck/country.dart';
import 'package:covicheck/radial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart' as http;

Future<String> fetchCountry(http.Client client) async {
  final response = await client.get(Uri.https(
    "disease.sh",
    "v3/covid-19/countries",
  ));
  // Use the compute function to run parsePhotos in a separate isolate
  return response.body;
}

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  //it will hold search box value
  TextEditingController _searchQuery;
  bool _isSearching = false; //maintain search box on/off state

  List<Country> filteredRecored;
  //getting data from the server
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    fetchCountry(new http.Client()).then((String) {
      parseData(String);
    });
  }

  List<Country> allRecord;
//parsing server response.
  parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
      allRecord =
          parsed.map<Country>((json) => new Country.fromJson(json)).toList();
    });
    filteredRecored = new List<Country>();
    filteredRecored.addAll(allRecord);
  }

  //It'll open search box
  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  //It'll close search box.
  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      filteredRecored.addAll(allRecord);
    });
  }

  //clear search box data.
  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  //Create a app bar title widget
  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text(
              'Seach box',
              style: new TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  //Creating search box widget
  Widget _buildSearchField() {
    return new Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 0),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(4278656558),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
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
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.69,
                  child: Material(
                    color: Colors.transparent,
                    child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        onChanged: updateSearchQuery,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search For A Country',
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w400),
                            contentPadding:
                                EdgeInsets.only(top: 0, bottom: 2))),
                  ),
                ),
              ],
            )));
  }

  //It'll update list items atfer searching complete.
  void updateSearchQuery(String newQuery) {
    filteredRecored.clear();
    if (newQuery.length > 0) {
      Set<Country> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }
    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
    }
    setState(() {});
  }

  //Filtering the list item with found match string.
  filterList(Country country, String searchQuery) {
    setState(() {
      if (country.name.toLowerCase().contains(searchQuery) ||
          country.name.contains(searchQuery)) {
        filteredRecored.add(country);
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(4278656558),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSearchField(),
              // SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: filteredRecored != null && filteredRecored.length > 0
                      ? new CountyList(country: filteredRecored)
                      : allRecord == null
                          ? new Center(child: new CircularProgressIndicator())
                          : new Center(
                              child: new Text("No recored match!"),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
