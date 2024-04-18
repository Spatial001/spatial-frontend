class GetPostBody {
  List<double>? coords;
  int? minD;
  int? maxD;
  int? lim;
  int? skipTo;

  GetPostBody({this.coords, this.minD, this.maxD, this.lim, this.skipTo});

  GetPostBody.fromJson(Map<String, dynamic> json) {
    coords = json['coords'].cast<double>();
    minD = json['minD'];
    maxD = json['maxD'];
    lim = json['lim'];
    skipTo = json['skipTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coords'] = coords;
    data['minD'] = minD;
    data['maxD'] = maxD;
    data['lim'] = lim;
    data['skipTo'] = skipTo;
    return data;
  }
}