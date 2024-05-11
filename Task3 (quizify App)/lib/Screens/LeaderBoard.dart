import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/QuizResult.dart';
import 'package:quizify/Widgets/Shapes.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key, required this.quizId});
  final String quizId;

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  String first = "first";
  String second = "second";
  String third = "third";
  bool loading = false;
  bool filterVisiblity = false;
  String selectedLevel = "EASY";

  @override
  void initState() {
    super.initState();
    getToppers();
  }

  Future<void> getToppers() async {
    setState(() {
      loading = true;
    });
    await quiz
        .doc(widget.quizId)
        .collection("Result")
        .orderBy("percentage", descending: true)
        .where("level", isEqualTo: selectedLevel)
        .get()
        .then((value) {
      setState(() {
        first = "first";
        second = "second";
        third = "third";
      });
      List<DocumentSnapshot> documents = value.docs;
      if (documents.isNotEmpty) {
        var firstData = documents.first.data() as Map<String, dynamic>;
        setState(() {
          if (firstData.isNotEmpty && firstData['name'] != null) {
            first = firstData['name'];
          }
        });
      }
      if (documents.length >= 2) {
        var secondData = documents[1].data() as Map<String, dynamic>;
        setState(() {
          if (secondData.isNotEmpty && secondData['name'] != null) {
            second = secondData['name'];
          }
        });
      }
      if (documents.length >= 3) {
        var thirdData = documents[2].data() as Map<String, dynamic>;
        setState(() {
          if (thirdData.isNotEmpty && thirdData['name'] != null) {
            third = thirdData['name'];
          }
        });
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  backgroundColor: Colors.blue,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    DropdownButton<String>(
                      value: selectedLevel,
                      iconEnabledColor: Colors.white,
                      iconDisabledColor: Colors.white70,
                      style: style.copyWith(color: Colors.white),
                      dropdownColor: Colors.black.withOpacity(0.5),
                      underline: Container(
                        height: 1,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedLevel = newValue!;
                        });
                        await getToppers();
                      },
                      items: <String>['EASY', 'NORMAL', 'HARD']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: style,
                          ),
                        );
                      }).toList(),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.leaderboard,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Leader Board",
                          style: style,
                        ),
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 16.0),
                    centerTitle: true,
                    background: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  CustomPaint(
                                    size: const Size(20, 20),
                                    painter: Star2Painter(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 120,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: Colors.yellow.shade800,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white30,
                                      child: Text(
                                        "2",
                                        style: GoogleFonts.balooDa2(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$second",
                                    style: style.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomPaint(
                                    size: const Size(20, 20),
                                    painter: Star1Painter(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 150,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade800,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white30,
                                      child: Text(
                                        "1",
                                        style: GoogleFonts.balooDa2(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$first",
                                    style: style.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomPaint(
                                    size: const Size(20, 20),
                                    painter: Star3Painter(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(15),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white30,
                                      child: Text(
                                        "3",
                                        style: GoogleFonts.balooDa2(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$third",
                                    style: style.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: quiz
                      .doc(widget.quizId)
                      .collection('Result')
                      .orderBy("percentage", descending: true)
                      .where("level", isEqualTo: selectedLevel)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                            child:
                                Text(style: style, 'Error: ${snapshot.error}')),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      QuerySnapshot querySnapshot = snapshot.data!;
                      List<DocumentSnapshot> documents = querySnapshot.docs;

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            Result result = Result.fromMap(data);

                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: Column(
                                children: [
                                  Card(
                                      child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  style: style,
                                                  "Name : ${result.name}"),
                                              Text(
                                                style: style,
                                                "Email : ${result.email}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                  style: style,
                                                  "Percentage : ${result.percentage.toStringAsFixed(2)}"),
                                              Text(
                                                "Grade : ${result.grade}",
                                                style: style.copyWith(
                                                    color: (result.grade != 'F')
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index == 0)
                                          Expanded(
                                              flex: 3,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                child: CircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://th.bing.com/th/id/R.6954c5e1d92866ee2a6ffd4870680d45?rik=kQ5B%2bCevJhSFBg&riu=http%3a%2f%2fclipart-library.com%2fimages_k%2ftrophy-png-transparent%2ftrophy-png-transparent-2.png&ehk=SSKEL1GUZCWRR%2bMkmGHT3tstKDkv6kBJEdf4NrDWa8E%3d&risl=&pid=ImgRaw&r=0"),
                                                ),
                                              )),
                                        if (index == 1)
                                          Expanded(
                                              flex: 3,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                child: CircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://th.bing.com/th/id/R.44c63ba71521a6fd80a84fb3b8f7e024?rik=fnqTyCmllkH5UA&riu=http%3a%2f%2fclipart-library.com%2fimages%2fgTe5G58Rc.png&ehk=9om4XTZrlzB0Oqy6K%2fLlhXasLVtU%2fPpdeDvVUymxiO0%3d&risl=&pid=ImgRaw&r=0"),
                                                ),
                                              )),
                                        if (index == 2)
                                          Expanded(
                                              flex: 3,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                child: CircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://th.bing.com/th/id/R.f69a5543840ec7e88c3bf76bc7525231?rik=o6KLXSWqao7DRg&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f71-713832_trophy-transparent-background-silver-trophy-png.png&ehk=YHRvQ%2bOBVP%2fqgDZeCQXFBsQAeWgdo9JiXOAqUf2FWQA%3d&risl=&pid=ImgRaw&r=0"),
                                                ),
                                              )),
                                        if (index != 0 &&
                                            index != 1 &&
                                            index != 2)
                                          Expanded(
                                              flex: 3,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                child: Text(
                                                    style: style,
                                                    "Rank:${index + 1}"),
                                              )),
                                      ],
                                    ),
                                  )),
                                  // if (index == snapshot.data!.docs.length - 1)
                                  //   Column(
                                  //     children: [
                                  //       ListTile(
                                  //         title: Text(
                                  //             style: style,
                                  //             "Document ID: ${document.id}"),
                                  //         subtitle: Text(
                                  //             style: style,
                                  //             "Data: ${document.data()}"),
                                  //       ),
                                  //       const SizedBox(
                                  //         height: 20,
                                  //       ),
                                  //     ],
                                  //   ),
                                ],
                              ),
                            );
                          },
                          childCount: documents
                              .length, // Use the length of the documents list
                        ),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: Center(
                            child: Text(style: style, 'No data available')),
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }
}
