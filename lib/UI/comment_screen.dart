import 'dart:convert';
import 'dart:developer';
import 'package:bluemint/models/create_comment_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/uiColors.dart';
import '../models/comments.dart';
import '../models/postbody.dart';
import '../services/api_services.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late ScrollController _controller;
  final commentController = TextEditingController();
  var posts = [];
  var comments = [];
  @override
  void initState() {
    super.initState();
    getPostFromId(widget.postId);
    _controller = ScrollController();
  }

  Future getPostFromId(String postId) async {
    var postIdList = [postId];
    PostBodyFromId data = PostBodyFromId(
      postIDS: postIdList,
      lim: 5,
      skipTo: 0,
    );
    var response = await postFromId(data);
    if (response?.statusCode == 200) {
      final jsonvar = jsonDecode(response!.body);
      setState(() {
        posts = jsonvar["posts"];
        // commentsList = posts[0]["comments"];
        getComments(posts[0]["comments"]);
        // comments = jsonvar["posts"][0]['"comments'];
      });
    } else {
      var error = jsonDecode(response!.body);
      log(error.toString());
    }
  }

  Future getComments(List<dynamic> commentId) async {
    CommentsModel data = CommentsModel(
      comments: commentId,
    );
    var response = await getCommentsApi(data);
    if (response?.statusCode == 200) {
      final jsonvar = jsonDecode(response!.body);
      for (var i = 0; i < jsonvar['comments'].length; i++) {
        comments.add(jsonvar['comments'][i]['msg']);
      }
      log(comments.toString());
      setState(() {});
    } else {
      var error = jsonDecode(response!.body);
      log(error.toString());
    }
  }

  Future createComment() async {
    CreateCommentBody data =
        CreateCommentBody(msg: commentController.text, postID: widget.postId);
    var response = await createCommentApi(data);
    // log(response!.statusCode.toString());
    if (response?.statusCode == 200) {
      log("Comment Created");
    } else {
      var error = jsonDecode(response!.body);
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          comments.isEmpty
              ? const Center(child: Text("No comments Till now"))
              : Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Pallete.whiteColor,
                        title: Column(
                          children: [
                            Text(
                              comments[index],
                              style: const TextStyle(fontSize: 18),
                            ).animate().fadeIn(duration: 800.ms),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Pallete.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0)
                      .copyWith(bottom: 5),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Pallete.whiteColor,
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: "Enter comment here",
                      suffixIcon: InkWell(
                        onTap: () {
                          if (commentController.text.isNotEmpty) {
                            createComment();
                            setState(() {
                              comments.add(commentController.text);
                            });
                            commentController.clear();
                          }
                        },
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
