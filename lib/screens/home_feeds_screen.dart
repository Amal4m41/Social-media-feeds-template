import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:social_media_feeds_template/backend/firebase/firestore_db.dart';
import 'package:social_media_feeds_template/utils/util_functions.dart';

import '../../components/post_item.dart';
import '../../models/post_model.dart';

class HomeFeedsScreen extends StatefulWidget {
  const HomeFeedsScreen({Key? key}) : super(key: key);

  @override
  State<HomeFeedsScreen> createState() => _HomeFeedsScreenState();
}

class _HomeFeedsScreenState extends State<HomeFeedsScreen> {
  final _fetchPostsQuery = FirebaseFirestore.instance.collection('posts').orderBy('createdTimeStamp', descending: true);

  void _addDummyPostData(int numberOfPosts) async {
    for (int i = 0; i < numberOfPosts; i++) {
      try {
        await FireStoreDB.createNewRandomPost();
        print('Success');
      } catch (e) {
        showCustomSnackBar(context: context, message: '$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _addDummyPostData(20);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'HomeScreen',
          style: TextStyle(color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add_box_outlined),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.favorite_border),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.chat),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      //FirestoreListView shows the real time data, building widgets lazily. Thus working great for infinite scroll list including
      //optimization with pagination.
      body: FirestoreListView(
        padding: const EdgeInsets.symmetric(vertical: 3),
        query: _fetchPostsQuery,
        pageSize: 10, //pagination with 10 records/posts loaded at a time.
        itemBuilder: (BuildContext context, QueryDocumentSnapshot<dynamic> doc) {
          final Map<String, dynamic> postData = doc.data();
          return PostItem(post: PostModel.fromJson(postData));
        },
        loadingBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context, error, _) => const Center(child: Text('Error occurred, please try again later')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        // backgroundColor: Colors.purple,
        onPressed: () {
          _addDummyPostData(1);
        },
        elevation: 5,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Add Post',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
