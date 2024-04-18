import 'dart:convert';
import 'dart:developer';
import 'package:bluemint/models/vote_body.dart';
import 'package:bluemint/services/api_services.dart';

void upVote(String? userId, String postId) async {
  VoteBody data = VoteBody(voteID: postId);
  var response = await upVotePost(data);
  if (response?.statusCode == 200) {
    log(response.toString());
  } else {
    var error = jsonDecode(response!.body);
    log(error.toString());
  }
}

void downVote(String? userId, String postId) async {
  VoteBody data = VoteBody(voteID: postId);
  var response = await downVotePost(data);
  if (response?.statusCode == 200) {
    log(response!.toString());
  } else {
    var error = jsonDecode(response!.body);
    log(error.toString());
  }
}
