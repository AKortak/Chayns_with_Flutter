import 'package:flutter_chayns/chaynsbottomnavigationbar.dart';
import 'package:flutter_chayns/searchbar.dart';
import 'package:flutter_chayns/webview.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Database/db.dart';
import 'Objects/chaynslocation.dart';
import 'appbar.dart';
import 'package:flutter/material.dart';

import 'chaynsgrid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "";
  PanelController panelController = new PanelController();
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showScaff = true;
  String linkToSite = "";

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        visible ? panelController.hide() : panelController.show();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          bottomNavigationBar: ChaynsBottomNavigationBar(
            returnToScaff: (val) {
              setState(() {
                showScaff = val;
              });
            },
          ),
          body: SlidingUpPanel(
            controller: panelController,
            panel: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            onPanelClosed: () => controller?.pauseCamera(),
            onPanelOpened: () => controller?.resumeCamera(),
            minHeight: 25,
            maxHeight: 400,
            collapsed: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(color: Colors.white30, width: 0.2)),
                color: Color.fromARGB(255, 40, 40, 40),
              ),
              child: Container(
                width: 35,
                height: 5,
                color: Colors.white30,
              ),
            ),
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 0),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: showScaff
                  ? ChaynsScaffold(
                      text: "",
                      onSiteButtonPressed: (val) {
                        setState(() {
                          linkToSite = val;
                          showScaff = false;
                        });
                      },
                    )
                  : WebViewContainer(url: linkToSite),
            ),
          ),
        ),
      ),
    );
  }
}

class ChaynsScaffold extends StatefulWidget {
  String text = "";
  ChaynsScaffold({this.text, this.onSiteButtonPressed});
  Function(String) onSiteButtonPressed;

  @override
  _ChaynsScaffoldState createState() => _ChaynsScaffoldState(text: text, onSiteButtonPressed: onSiteButtonPressed);
}

class _ChaynsScaffoldState extends State<ChaynsScaffold> {
  _ChaynsScaffoldState({this.text, this.onSiteButtonPressed});
  String text = "";
  Function(String) onSiteButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChaynsAppBar(),
      extendBodyBehindAppBar: false,
      backgroundColor: Color.fromARGB(255, 25, 25, 25),
      body: Column(
        children: [
          ChaynsSearchBar(
            onChanged: (value) {
              setState(() {
                value = value.toString().toLowerCase();
                text = value;
              });
            },
          ),
          FutureBuilder(
            future: Locations().fetchSitesFromSearch(text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.hasData
                    ? ChaynsGridView(
                        onSiteButtonPressed: (value) {
                          onSiteButtonPressed(value);
                        },
                        gridSiteList: snapshot.data,
                      )
                    : Center(child: CircularProgressIndicator());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
