import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/post_model.dart';
import '../../utils/custom_exceptions.dart';

//List of image urls that's uploaded to firebase storage.
const _imageUrls = [
  'https://images.unsplash.com/photo-1653958531645-fef7d3b83fc8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Fscott-webb-e6VmcXF8llA-unsplash.jpg?alt=media&token=c70c3147-b15c-472b-bacb-5f610e3ad338',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Frui-silvestre-9vxJQmZmTYU-unsplash.jpg?alt=media&token=f5147970-75cd-4b43-bcb6-95fcefa3c989',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Fmauro-lima-3bNgi5QAFuc-unsplash.jpg?alt=media&token=93c8b77f-3a28-4400-a565-03aa65a19fc7',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Fmarek-piwnicki-iAMI6FXaOQM-unsplash.jpg?alt=media&token=9f89ac5a-9d7f-4b5e-bd64-fcc18748d650',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Felia-pellegrini-5B9l8fZmFhM-unsplash.jpg?alt=media&token=8be32604-8f66-4eb3-8ba4-89f565665316',
  'https://firebasestorage.googleapis.com/v0/b/social-media-feeds-fb.appspot.com/o/posts_media%2Fdynamic-wang-6ZwbwgyaxRY-unsplash.jpg?alt=media&token=d62ad0e6-5f5a-4653-975f-5cc6d534d2e9'
];

class FireStoreDB {
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Custom exception is used to rethrow/throw exception with messages that to be shown to the end user.
  static Future<void> createNewRandomPost() async {
    try {
      PostModel postToBeUploaded = PostModel(
        imageUrl: _imageUrls[Random().nextInt(_imageUrls.length - 1)], //get a random post image url
        caption:
            'This is the description of the post, it could contain the contact details and information related to a product, service etc.',
        createdUserUUID: '',
        likes: [],
        createdTimeStamp: DateTime.now(),
      );

      await _firebaseFirestore.collection('posts').add(postToBeUploaded.toJson());
    } on Failure catch (e) {
      print(e);
      rethrow;
    } on FirebaseAuthException catch (e) {
      //TODO: to handle different kinds of firebase exceptions with respective user msgs.
      print(e);
      throw const Failure('Some firebase exception');
      //These errors can be caught in the ui and shown respective messages.
    } catch (e) {
      print(e);
      throw const Failure('Some other exception');
    }
  }
}
