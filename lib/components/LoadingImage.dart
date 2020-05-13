import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/utils/Colors.dart';

class LoadingImage extends StatelessWidget {
  final String url;

  const LoadingImage({this.url});

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      image: AdvancedNetworkImage(
        this.url,
        useDiskCache: true,
        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
      ),
      fit: BoxFit.cover,
      placeholder: CircularProgressIndicator(),
      // This is default duration
      duration: Duration(milliseconds: 300),
    );
  }
}