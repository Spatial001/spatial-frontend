class VoteBody {
  String? voteID;

  VoteBody({this.voteID});

  VoteBody.fromJson(Map<String, dynamic> json) {
    voteID = json['voteID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voteID'] = voteID;
    return data;
  }
}
