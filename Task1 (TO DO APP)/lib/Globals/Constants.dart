import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

CollectionReference users = FirebaseFirestore.instance.collection("Users");

CollectionReference tasks = users.doc(currentUser?.uid).collection("Tasks");

User? currentUser = FirebaseAuth.instance.currentUser;

TextStyle titleStyle = GoogleFonts.poppins(fontSize: 17);
TextStyle subTitleStyle = GoogleFonts.poppins(fontSize: 13);
TextStyle headLineStyle = GoogleFonts.poppins(fontSize: 25);
Color appBarBackgroundColor = Colors.deepPurple;
Color appBarForegroundColor = Colors.white;
