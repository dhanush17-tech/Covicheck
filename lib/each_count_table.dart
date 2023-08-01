import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Man {
  final String date;
  final int new_confirmed;
  final int new_recovered;
  final int new_deaths;
  Man({
    this.new_confirmed,
    this.new_deaths,
    this.date,
    this.new_recovered,
  });

  factory Man.fromJson(Map<String, dynamic> json) {
    return Man(
      date: json["data"]["name"],
      new_confirmed: json["data"]["code"],
      new_deaths: json["timeline"]["new_deaths"],
      new_recovered: json["timeline"]["new_recovered"],
    );
  }
}

Future<List<Man>> fetchSummary() async {
  final response = await http.get(Uri(path: "https://corona-api.com/countries/kw"));

  if (response.statusCode == 200) {
    // var data =
    // '{ "Global": { "NewConfirmed": 100282, "TotalConfirmed": 1162857, "NewDeaths": 5658, "TotalDeaths": 63263, "NewRecovered": 15405, "TotalRecovered": 230845 }, "Countries": [ { "Country": "ALA Aland Islands", "CountryCode": "AX", "Slug": "ala-aland-islands", "NewConfirmed": 0, "TotalConfirmed": 0, "NewDeaths": 0, "TotalDeaths": 0, "NewRecovered": 0, "TotalRecovered": 0, "Date": "2020-04-05T06:37:00Z" },{ "Country": "Zimbabwe", "CountryCode": "ZW", "Slug": "zimbabwe", "NewConfirmed": 0, "TotalConfirmed": 9, "NewDeaths": 0, "TotalDeaths": 1, "NewRecovered": 0, "TotalRecovered": 0, "Date": "2020-04-05T06:37:00Z" } ], "Date": "2020-04-05T06:37:00Z" }';
    var parsed = json.decode(response.body);
    print(parsed.length);
    List jsonResponse = parsed as List;
    print(response.body);
    return jsonResponse.map((job) => new Man.fromJson(job)).toList();
  } else {
    print('Error, Could not load Data.');
    throw Exception('Failed to load Data');
  }
}

class Table extends StatefulWidget {
  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  final controller = ScrollController();
  double offset = 0;
  bool sortAscending = false;
  Future<List<Man>> _func;

  @override
  void initState() {
    _func = fetchSummary();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Man>>(
        future: _func,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<Man> data = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            sortAscending: false,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Country',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Confirmed',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontSize: 16.0,
                                  ),
                                ),
                                numeric: true,
                              )
                            ],
                            rows: data
                                .map(
                                  (country) => DataRow(
                                    cells: [
                                      DataCell(
                                        Container(
                                          width: 100,
                                          child: Text(
                                            country.date,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 60.0,
                                            child: Center(
                                              child: Text(
                                                country.new_confirmed
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                    ),
                  ),
                ),
                // SizedBox(height: 500),
              ],
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
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
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
