import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String imageUrl;
  final String caption;
  final String createdUserUUID;
  final List likes;
  final DateTime createdTimeStamp;

  PostModel({
    required this.imageUrl,
    required this.caption,
    required this.createdUserUUID,
    required this.likes,
    required this.createdTimeStamp,
  }); //who created this post.

  PostModel.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'],
        caption = json['caption'],
        likes = json['likes'],
        // createdTimeStamp = (json['createdTimeStamp'] as Timestamp).toDate(),
        createdTimeStamp = (json['createdTimeStamp'] as Timestamp).toDate(),
        createdUserUUID = json['createdUserUUID'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['caption'] = caption;
    data['likes'] = likes;
    data['createdTimeStamp'] = createdTimeStamp;
    data['createdUserUUID'] = createdUserUUID;
    return data;
  }
}
