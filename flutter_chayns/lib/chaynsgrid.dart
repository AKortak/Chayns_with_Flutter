import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chayns/Objects/chaynssite.dart';

class ChaynsGridView extends StatefulWidget {
  Function(String) onSiteButtonPressed;

  final List<Site> gridSiteList;
  ChaynsGridView({@required this.onSiteButtonPressed, @required this.gridSiteList});

  @override
  _ChaynsGridViewState createState() => _ChaynsGridViewState(onSiteButtonPressed: onSiteButtonPressed, gridSiteList: gridSiteList);
}

class _ChaynsGridViewState extends State<ChaynsGridView> {
  Function(String) onSiteButtonPressed;

  final List<Site> gridSiteList;
  _ChaynsGridViewState({this.onSiteButtonPressed, this.gridSiteList});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 4.0,
                children: gridSiteList.map(
                  (e) {
                    return GestureDetector(
                      onTap: () {
                        onSiteButtonPressed("https://chayns.net/${e.siteId}");
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Image.file(
                                File(
                                  e.pathToPic.substring(8, e.pathToPic.length - 1),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 25,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    e.name == null ? e.locationName : e.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
