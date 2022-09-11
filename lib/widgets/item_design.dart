import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/models/global.dart';
import 'package:sellers_app/models/items.dart';
import 'package:sellers_app/screens/item_detail_screen.dart';

class ItemsDesignWidget extends StatefulWidget {
  const ItemsDesignWidget(
      {Key? key, required this.model, required this.context})
      : super(key: key);

  final Items? model;
  final BuildContext? context;

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  deleteItem(String itemId) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuId!)
        .collection("items")
        .doc(itemId)
        .delete().then((value) {
          FirebaseFirestore.instance.collection("items").doc(itemId).delete();
    });
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Item Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => ItemDetailScreen(model: widget.model)),
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 2),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 18,
                  fontFamily: "Train",
                ),
              ),
              const SizedBox(height: 2),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2),
              Text(
                widget.model!.description!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
