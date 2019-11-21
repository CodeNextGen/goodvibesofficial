import 'package:equatable/equatable.dart';

class Categories {
  int id, key, trackCount, gid;
  String name, description, image, gname, gimage;

  Categories(
      {this.id,
      this.name,
      this.description,
      this.trackCount,
      this.image,
      this.gid,
      this.gimage,
      this.gname,
      this.key});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['id'],
        key: int.tryParse(json['key']),
        name: json['name'],
        description: json['description'] ?? ' ',
        image: json['category_image'] ?? 'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        gid: json['genre']['id'],
        gimage: json['genre']['genre_image'] ?? 'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        gname: json['genre']['name'] ?? ' ',
        trackCount: json['track_count']);
  }
}

class Albums {
  int id, key, trackCount;
  String title, image;

  Albums({this.id, this.title, this.trackCount, this.image, this.key});

  factory Albums.fromJson(Map<String, dynamic> json) {
    return Albums(
        id: json['id']??0,
        key: int.tryParse(json['key'])??0,
        title: json['title']??' ',
        image: json['album_image']??'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        trackCount: json['track_count']??0);
  }
}

class Genre {
  int id;
  String name, image, imageStandard ;

  Genre({this.id, this.name, this.imageStandard, this.image});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
        id: json['id'],
        name: json['name']??'',
        image: json['genre_image']??'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        imageStandard: json['genre_image_standard']??'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg');
  }
}

class Track extends Equatable {
   final int id, cid,gid,playCount;
  final String title, filename, description, url, image, duration, cname, gname, composer;

  Track(
      {this.id,
      this.playCount,
      this.title,
      this.gid,
      this.gname,
      this.description,
      this.url,
      this.image,
      this.duration,
      this.cid,
      this.filename,
      this.composer,
      this.cname});


  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
        id: json['id'],
        cid: json['category'] == null ? 0 : json['category']['id'],
        gid: json['genre'] == null ? 0 : json['genre']['id'],
        title: json['name'],
        playCount: json['play_count'],
        description: json['description'] ?? '',
        url: json['track_url'],
        filename: json['filename'] ?? json['track_url'].toString().split('/').last,
        image: json['track_image']??'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        duration: json['duration'],
        composer: json['composer_name'],
        cname: json['category'] == null ? ' ' : json['category']['name'],
        gname: json['genre'] == null ? ' ' : json['genre']['name']);
  }
  factory Track.fromDb(Map<String, dynamic> db) {
    return Track(
        id: db['id'] ?? 0,
        cid: db['cid'] ?? 0,
        title: db['title'] ?? '',
        playCount: db['play_count'] ?? 0,
        description: db['description'] ?? '',
        url: db['url'] ?? '',
        filename: db['filename'] ?? '',
        image: db['image'] ?? '',
        duration: db['duration'] ?? '',
        composer: db['composer'] ?? '',
        cname: db['cname'] ?? '');
  }
  factory Track.fromDownload(Map<String, dynamic> db) {
    return Track(
        id: db['id'] ?? 0,
        cid: db['cid'] ?? 0,
        title: db['title'] ?? '',
        playCount: db['play_count'] ?? 0,
        description: db['description'] ?? '',
        url: db['url'] ?? '',
        filename: db['filename'] ?? '',
        image: db['image'] ?? 'https://nepalikart.com/wp-content/uploads/2019/09/placeholder.jpg',
        duration: db['duration'] ?? '',
        composer: db['composer'] ?? '',
        cname: db['cname'] ?? '');
  }

  @override
  List<Object> get props => [cid, id, cname,url,filename];
}
