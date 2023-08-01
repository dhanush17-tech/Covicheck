import 'package:covicheck/constrainsts.dart';
import 'package:covicheck/country_info.dart';
import 'package:covicheck/home.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<List<Summary>> func;

class Summary {
  final String country;
  final String iso2;
  final int totalConfirmed;
  Summary({this.country, this.totalConfirmed, this.iso2});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      country: json['country'],
      totalConfirmed: json["cases"],
      iso2: json["countryInfo"]["iso2"],
    );
  }
}

Future<List<Summary>> fetchSummary() async {
  final response = await http.get(Uri.https(
    "disease.sh",
    "v3/covid-19/countries",
  ));

  if (response.statusCode == 200) {
    // var data =
    // '{ "Global": { "NewConfirmed": 100282, "TotalConfirmed": 1162857, "NewDeaths": 5658, "TotalDeaths": 63263, "NewRecovered": 15405, "TotalRecovered": 230845 }, "Countries": [ { "Country": "ALA Aland Islands", "CountryCode": "AX", "Slug": "ala-aland-islands", "NewConfirmed": 0, "TotalConfirmed": 0, "NewDeaths": 0, "TotalDeaths": 0, "NewRecovered": 0, "TotalRecovered": 0, "Date": "2020-04-05T06:37:00Z" },{ "Country": "Zimbabwe", "CountryCode": "ZW", "Slug": "zimbabwe", "NewConfirmed": 0, "TotalConfirmed": 9, "NewDeaths": 0, "TotalDeaths": 1, "NewRecovered": 0, "TotalRecovered": 0, "Date": "2020-04-05T06:37:00Z" } ], "Date": "2020-04-05T06:37:00Z" }';
    var parsed = json.decode(response.body);
    // print(parsed.length);
    List jsonResponse = parsed as List;

    return jsonResponse.map((job) => new Summary.fromJson(job)).toList();
  } else {
    print('Error, Could not load Data.');
    throw Exception('Failed to load Data');
  }
}

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final controller = ScrollController();
  double offset = 0;
  bool sortAscending = false;

  @override
  void initState() {
    controller.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  sort(List list) {
    list.sort((a, b) => b.totalConfirmed.compareTo(a.totalConfirmed));
    list.removeRange(5, list.length);

    if (!sortAscending) {
      list = list.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //  statusBarColor: Color(4294967295),
        statusBarIconBrightness: Brightness.dark));
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: FutureBuilder<List<Summary>>(
        future: func,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<Summary> data = snapshot.data;

            return Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: DataTable(
                          sortAscending: false,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Country',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              numeric: false,
                            ),
                            DataColumn(
                                label: Text(
                                  'Total Confirmed',
                                  style: TextStyle(
                                    color: kInfectedColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                numeric: true,
                                onSort: sort(data))
                          ],
                          rows: data
                              .map(
                                (country) => DataRow(
                                  cells: [
                                    DataCell(
                                      GestureDetector(
                                        onTap: () {
                                          display = country.iso2.toLowerCase();
                                          country_name = country.country;

                                          print(country.iso2);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Info_country()));
                                        },
                                        child: Container(
                                          child: Text(
                                            country.country,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                        onTap: () {
                                          display = country.iso2.toLowerCase();
                                          country_name = country.country;
                                          print(country.iso2);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Info_country()));
                                        },
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              country.totalConfirmed
                                                  .toString()
                                                  .replaceAllMapped(
                                                      new RegExp(
                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                      (Match m) => '${m[1]},'),
                                              style: TextStyle(
                                                  color: kInfectedColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text(
                'An Error Occured!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              content: Text(
                "${snapshot.error}",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            );
          }
          // By default, show a loading spinner.
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('This may take some time..')
              ],
            ),
          );
        },
      ),
    );
  }
}
