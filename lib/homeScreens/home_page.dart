import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:spatial/UI/comment_screen.dart';
import 'package:spatial/constants/uiColors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import '../Operations/api_functions.dart';
import '../constants/globals.dart';
import '../constants/locations.dart';
import '../models/get_post_body.dart';
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool res = false;
  var locList = [];
  String chosen = "";
  var skipval = 0;
  var posts = [];
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  Color? upVoteColor = Colors.black54;
  Color? downVoteColor = Colors.black54;
  String? userId = "";
  var upVoteMap = {};
  var downVoteMap = {};
  var upVoteCount = {};
  var downVoteCount = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createList();
    if (!isHomeLoaded) {
      reqPerm();
      isHomeLoaded = true;
    }
    scrollController.addListener(_scrollListener);
    getPost();
    getuserId();
  }

  Future<void> getuserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userId');
  }

  void createList() {
    for (var i in locationCoordinates.keys) {
      locList.add(i);
    }
  }

  void selectLoc() async {
    String chosenId = "";
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              itemCount: locList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    chosen = locList[index];
                    locateCoord = locationCoordinates[chosen];
                    Navigator.of(context).pop();
                    posts = [];
                    getPost();
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 10,
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            locList[index],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width),
                          child: Radio(
                            value: locList[index].toString(),
                            groupValue: chosenId,
                            onChanged: (value) {
                              setState(
                                () {
                                  chosen = locList[index].toString();
                                  chosenId = locList[index].toString();
                                  Navigator.of(context).pop();
                                  locateCoord = locationCoordinates[chosen];
                                  posts = [];
                                  getPost();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
    setState(() {});
  }

  Future reqPerm() async {
    res = await Permission.location.request().isGranted;
    if (!res) {
      Future.delayed(const Duration(milliseconds: 1), () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'This app requires location to perform correctly!',
          desc: 'Either grant location permission or choose location manually.',
          btnCancelText: "Open Settings",
          btnCancelOnPress: () {
            openAppSettings();
            Future.delayed(const Duration(milliseconds: 50), () {});
          },
          btnOkText: "Choose location",
          btnOkOnPress: () {
            selectLoc();
          },
          onDismissCallback: (type) {
            if (type != DismissType.btnOk && type != DismissType.btnCancel) {
              selectLoc();
            }
          },
        ).show();
      });
    } else {
      chooseLocation = false;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      locateCoord?.add(position.latitude);
      locateCoord?.add(position.longitude);
      getPost();
    }
  }

  Future getPost() async {
    GetPostBody data = GetPostBody(
      coords: locateCoord,
      minD: 0,
      maxD: dist[0] * 1000,
      lim: 5,
      skipTo: skipval,
    );
    var response = await getPostResponse(data);
    if (response?.statusCode == 200) {
      final jsonvar = jsonDecode(response!.body);
      log(dist.toString());
      setState(() {
        posts = posts + jsonvar['posts'];
        for (var i = 0; i < posts.length; i++) {
          upVoteMap[i] = posts[i]['upvotes'] != null &&
                  posts[i]['upvotes'].contains(userId)
              ? true
              : false;
          downVoteMap[i] = posts[i]['downvotes'] != null &&
                  posts[i]['downvotes'].contains(userId)
              ? true
              : false;

          upVoteCount[i] =
              posts[i]['upvotes'] != null ? posts[i]['upvotes'].length : 0;
          downVoteCount[i] =
              posts[i]['downvotes'] != null ? posts[i]['downvotes'].length : 0;
        }
      });
    } else {
      var error = jsonDecode(response!.body);
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
        actions: chooseLocation
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      selectLoc();
                    },
                    child: const Icon(Icons.location_pin),
                  ),
                )
              ]
            : null,
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                controller: scrollController,
                itemCount: isLoadingMore ? posts.length + 1 : posts.length,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Pallete.whiteColor,
                          contentPadding: const EdgeInsets.all(10),
                          title: Column(
                            children: [
                              Text(
                                posts[index]['title'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ZoomOverlay(
                                  minScale: 0.5, // Optional
                                  maxScale: 3.0, // Optional
                                  animationCurve: Curves
                                      .fastOutSlowIn, // Defaults to fastOutSlowIn which mimics IOS instagram behavior
                                  animationDuration: const Duration(
                                      milliseconds:
                                          500), // Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
                                  twoTouchOnly: true,
                                  child: Image.memory(
                                    const Base64Decoder()
                                        .convert(posts[index]['image']),
                                    gaplessPlayback: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (upVoteMap[index]) {
                                            upVoteCount[index] -= 1;
                                          } else {
                                            upVoteCount[index] += 1;
                                          }
                                          upVoteMap[index] = !upVoteMap[index];
                                          setState(() {
                                            upVote(
                                              userId,
                                              posts[index]['_id'],
                                            );
                                            if (downVoteMap[index]) {
                                              downVoteMap[index] = false;
                                              downVoteCount[index] =
                                                  downVoteCount[index] - 1;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.keyboard_double_arrow_up,
                                          color: upVoteMap[index] != null &&
                                                  upVoteMap[index]
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ),
                                      Text((upVoteCount[index] -
                                              downVoteCount[index])
                                          .toString()),
                                      IconButton(
                                        onPressed: () {
                                          if (downVoteMap[index]) {
                                            downVoteCount[index] -= 1;
                                          } else {
                                            downVoteCount[index] += 1;
                                          }
                                          downVoteMap[index] =
                                              !downVoteMap[index];
                                          setState(() {
                                            downVote(
                                              userId,
                                              posts[index]['_id'],
                                            );
                                            if (upVoteMap[index]) {
                                              upVoteMap[index] = false;
                                              upVoteCount[index] =
                                                  upVoteCount[index] - 1;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.keyboard_double_arrow_down,
                                          color: downVoteMap[index] != null &&
                                                  downVoteMap[index]
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return CommentScreen(
                                                postId: posts[index]['_id']);
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.comment),
                                        Text(
                                            '   ${posts[index]['comments'].length}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(60.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
    );
  }

  void _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      skipval += 5;
      getPost();
      setState(() {
        isLoadingMore = false;
      });
    }
  }
}
