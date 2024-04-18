class CreatePost {
  List<double>? coords;
  String? title;
  String? image;
  CreatePost({this.coords, this.title, this.image});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['coords'] = coords;
    data['image'] = image;
    return data;
  }
}
