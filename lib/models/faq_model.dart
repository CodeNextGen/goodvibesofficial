class FaqModel {
  int id;
  String title, content ;

  FaqModel({this.id, this.title, this.content});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
        id: json['id'],
        title: json['title']??'',
        content: json['content']??'');
  }
}