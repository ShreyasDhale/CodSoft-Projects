import 'package:flutter/material.dart';

//

Map<String, dynamic> currentUser = {};

List<Color> colors = [
  Colors.red,
  Colors.blue,
  Colors.deepPurple,
  Colors.yellow,
  Colors.green,
];

List<int> shuffledIndices = [];

// Functions

int getIndex(int max) {
  if (shuffledIndices.isEmpty) {
    shuffledIndices = List<int>.generate(max, (index) => index);
    shuffledIndices.shuffle();
  }
  return shuffledIndices.removeLast();
}

void Print(String msg) {
  print("*******************************************************");
  print("$msg");
  print("*******************************************************");
}
