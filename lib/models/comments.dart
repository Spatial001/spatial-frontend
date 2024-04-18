class CommentsModel {
  List<dynamic>? comments;

  CommentsModel({this.comments});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    comments = json['comments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comments'] = comments;
    return data;
  }
}
