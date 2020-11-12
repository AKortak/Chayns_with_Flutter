import 'package:flutter/material.dart';

class ChaynsAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _ChaynsAppBarState createState() => _ChaynsAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}

class _ChaynsAppBarState extends State<ChaynsAppBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Center(
              child: CircleAvatar(
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Text(
                    "chayns®",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                  ),
                ),
                radius: 18,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        )
      ],
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Hallo Ali!",
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
