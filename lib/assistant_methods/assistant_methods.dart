import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/global.dart';

separateOrderItemIDs(orderIDs) {
  List<String> separateItemIDsList = [], defaultItemList = [];

  defaultItemList = List<String>.from(orderIDs);

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIDsList.add(getItemId);
  }

  return separateItemIDsList;
}

separateItemIDs() {
  List<String> separateItemIDsList = [], defaultItemList = [];

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIDsList.add(getItemId);
  }

  return separateItemIDsList;
}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemQuantitiesList = [];
  List<String> defaultItemList = [];

  defaultItemList = List<String>.from(orderIDs);

  for (int i = 1; i < defaultItemList.length; i++) {
    //55565767:7
    String item = defaultItemList[i].toString();

    //7
    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantitiesList.add(quantityNumber.toString());
  }

  return separateItemQuantitiesList;
}

separateItemQuantities() {
  List<int> separateItemQuantitiesList = [];
  List<String> defaultItemList = [];

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (int i = 1; i < defaultItemList.length; i++) {
    //55565767:7
    String item = defaultItemList[i].toString();

    //7
    List<String> listItemCharacters = item.split(":").toList();

    var quantityNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantitiesList.add(quantityNumber);
  }

  return separateItemQuantitiesList;
}

clearCartNow(context) {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);
  });
}

myBoxDecoration(Color color1, Color color2) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        color1,
        color2,
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: const [0.0, 1.0],
      tileMode: TileMode.clamp,
    ),
  );
}
