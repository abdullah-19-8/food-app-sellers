import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/models/global.dart';
import 'package:sellers_app/widgets/simple_app_bar.dart';
import '../models/items.dart';

class ItemDetailScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  deleteItem(String itemId) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuId!)
        .collection("items")
        .doc(itemId)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("items").doc(itemId).delete();
    });
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Item Deleted");
  }

  TextEditingController counterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.network(widget.model!.thumbnailUrl.toString()),
          ),
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.model!.title.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.model!.description.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    " ${widget.model!.price} \$",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: () {
                      deleteItem(widget.model!.itemId!);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber,
                            Colors.cyan,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 15,
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Delete Item!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
