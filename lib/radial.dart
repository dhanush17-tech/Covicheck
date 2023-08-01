import 'package:covicheck/country.dart';
import 'package:covicheck/country_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class CountyList extends StatefulWidget {
  final List<Country> country;

  CountyList({Key key, this.country}) : super(key: key);

  @override
  _CountyListState createState() => _CountyListState();
}

class _CountyListState extends State<CountyList> {
  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
        separatorBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: Divider(),
          );
        },
        shrinkWrap: true,
        itemCount: widget.country == null ? 0 : widget.country.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  display = widget.country[index].code.toLowerCase();
                  country_name = widget.country[index].name;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Info_country()));
                print(widget.country[index].code);
              },
              child: new Container(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(widget.country[index].flag),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.country[index].name,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 10, bottom: 10, top: 10),
              ),
            ),
          );
        });
  }
}
