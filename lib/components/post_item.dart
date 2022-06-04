import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../models/post_model.dart';
import '../utils/file_operations.dart';
import '../utils/util_functions.dart';

// const dummyImage =
//     'https://images.unsplash.com/photo-1653958531645-fef7d3b83fc8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';

class PostItem extends StatelessWidget {
  final PostModel post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration:
          const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 0.0), //(x,y)
          blurRadius: 20.0,
        ),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: getImage(source: getImageFrom.defaultData, data: null),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Username', //the user name could be stored in with the posts or can be fetched using the user uuid stored in posts.
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Location of the user',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Expanded(child: SizedBox()),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ))
              ],
            ),
          ),
          Container(
            height: 220,
            width: double.infinity,
            child: FadeInImage(
              image: getImage(source: getImageFrom.network, data: post.imageUrl),
              placeholder: const AssetImage('assets/pics/place_holder.png'),
              fit: BoxFit.fill,
            ),
            // DecorationImage(image: getImage(source: getImageFrom.network, data: post.imageUrl), fit: BoxFit.fill),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                    color: Colors.grey,
                  )),
              IconButton(
                  onPressed: () async {
                    // final url = http.get(Uri.parse(dummyImage));
                    try {
                      http.Response response = await http.get(Uri.parse(post.imageUrl));
                      Uint8List data = response.bodyBytes;
                      //storing the file temporarily on the phone
                      final temp = await getTemporaryDirectory();
                      print(temp.path);
                      final path = '${temp.path}/image.jpg';
                      File(path).writeAsBytes(data);

                      // await Share.share('This is a sample text');
                      await Share.shareFiles([path], text: post.caption);
                    } catch (e) {
                      print('EXCEPTION SHARING: $e');
                      showCustomSnackBar(context: context, message: 'Failed to share post, please try again later');
                    }
                  },
                  icon: const Icon(Icons.share)),
              const SizedBox(width: 3),
              const Expanded(
                child: SizedBox(),
              ),
              DownloadLoadingWidget(downloadFileUrl: post.imageUrl),
            ],
          ),
          //caption, likes and comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              '${post.likes.length} likes',
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(text: 'Description: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: post.caption)
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              '0 comments',
              maxLines: 1,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              DateFormat('yyyy-MM-dd H:m:s').format(post.createdTimeStamp),
              maxLines: 1,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          const SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}

//Extracted to separate widget to reduce build of the parent widget.
class DownloadLoadingWidget extends StatefulWidget {
  final String downloadFileUrl;
  const DownloadLoadingWidget({Key? key, required this.downloadFileUrl}) : super(key: key);

  @override
  State<DownloadLoadingWidget> createState() => _DownloadLoadingWidgetState();
}

class _DownloadLoadingWidgetState extends State<DownloadLoadingWidget> {
  bool _isDownloading = false;
  double _downloadProgress = 0;

  void downloadFile({required String fileUrl, required String extension}) async {
    setState(() {
      _isDownloading = true;
    });

    SaveFileOperationResponse isDownloaded = await FileOperations.saveFile(
      url: fileUrl, //link
      filename: fileUrl.split('/').last + extension, //the name of the file.
      // folderName: "SocialMediaFeedsTemplateApp",
      downloadProgressCallback: (downloadedSize, totalSize) {
        setState(() {
          _downloadProgress = downloadedSize / totalSize;
        });
      },
    ); //name of the file
    if (isDownloaded == SaveFileOperationResponse.success) {
      print("Downloaded");
    } else if (isDownloaded == SaveFileOperationResponse.permissionError) {
      print('permission denied');
      showCustomSnackBar(
          context: context, bgColor: Colors.purple, message: "Please enable permission to download file");
    } else {
      print('error downloading');
      showCustomSnackBar(context: context, message: "Failed to download task, please try again later");
    }
    setState(() {
      _isDownloading = false;
      _downloadProgress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isDownloading
        ? Container(
            height: 22,
            width: 22,
            margin: const EdgeInsets.only(right: 25),
            child: CircularProgressIndicator(
              color: Colors.blue,
              backgroundColor: Colors.blue.shade200,
              value: _downloadProgress,
              strokeWidth: 3,
            ),
          )
        : InkWell(
            onTap: () {
              downloadFile(fileUrl: widget.downloadFileUrl, extension: '.jpg');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 3),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.black)),
              child: Row(
                children: const [Text('Download'), Icon(Icons.download_rounded)],
              ),
            ),
          );
    // : IconButton(
    //     onPressed: () {
    //       downloadFile(fileUrl: widget.downloadFileUrl, extension: '.jpg');
    //     },
    //     icon: const Icon(Icons.arrow_circle_down));
  }
}
