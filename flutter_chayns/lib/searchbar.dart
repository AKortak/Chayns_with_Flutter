import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'debounce.dart';

class ChaynsSearchBar extends StatelessWidget {
  ChaynsSearchBar({
    this.onChanged,
  });

  final Function(String x) onChanged;
  final Debouncer onSearchDebouncer = new Debouncer(delay: new Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 50,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        children: [
          TextField(
            autofocus: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              icon: Icon(
                Icons.search,
                color: Colors.white30,
              ),
              hintText: 'Finden',
              hintStyle: TextStyle(color: Colors.white30),
            ),
            onChanged: (val) => onSearchDebouncer.debounce(
              () => onChanged(val),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              child: Container(
                color: Colors.white,
                height: 50,
                width: 50,
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.blue,
                  size: 33,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
