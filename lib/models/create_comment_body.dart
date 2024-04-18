class CreateCommentBody {
  String? msg;
  String? postID;

  CreateCommentBody({this.msg, this.postID});

  CreateCommentBody.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    postID = json['postID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['postID'] = postID;
    return data;
  }
}
