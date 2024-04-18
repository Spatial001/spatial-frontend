import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:spatial/models/comments.dart';
import 'package:spatial/models/postbody.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_url.dart';
import '../models/create_comment_body.dart';
import '../models/create_post.dart';
import '../models/get_post_body.dart';
import '../models/login.dart';
import '../models/vote_body.dart';

Future<http.Response?> login(LoginBody data) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse("${apiUrl}login"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data));
  } catch (e) {
    log(e.toString());
  }
  // if (response?.statusCode == 200) {
  //   jsonDecode(response!.body);
  // } else if (response?.statusCode == 400) {
  //   var error = jsonDecode(response!.body);
  //   warning = error['message'];
  // } else if (response?.statusCode == 404) {}

  return response;
}

Future<http.Response?> signup(LoginBody data) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse("${apiUrl}signup"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  // print(response.toString());
  return response;
}

Future<http.Response?> getPostResponse(GetPostBody data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/near'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> createPost(CreatePost data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/create'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> upVotePost(VoteBody data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/upvote'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> downVotePost(VoteBody data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/downvote'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> postFromId(PostBodyFromId data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/getPosts'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> getCommentsApi(CommentsModel data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/getComments'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}

Future<http.Response?> createCommentApi(CreateCommentBody data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('isLoggedIn');
  http.Response? response;
  try {
    response = await http.post(Uri.parse('${apiUrl}post/createComment'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}
