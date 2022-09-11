import 'package:flutter/material.dart';

class MyPadding extends StatelessWidget {
  final String? text;
  final VoidCallback? onTab;

  const MyPadding({Key? key, this.text, this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: InkWell(
          onTap: onTab,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            child: Center(
              child: Text(
                text!,
                style: const TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
