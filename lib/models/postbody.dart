class PostBodyFromId {
  List<String>? postIDS;
  int? lim;
  int? skipTo;

  PostBodyFromId({this.postIDS, this.lim, this.skipTo});

  PostBodyFromId.fromJson(Map<String, dynamic> json) {
    postIDS = json['postIDS'].cast<String>();
    lim = json['lim'];
    skipTo = json['skipTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postIDS'] = postIDS;
    data['lim'] = lim;
    data['skipTo'] = skipTo;
    return data;
  }
}
