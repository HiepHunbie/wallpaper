import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class DownloadImage {

  DownloadImage() {

  }

  Future<void> downloadImage(String url) async {
    try {
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      }
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }
}

