import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/utils/Colors.dart';

class ZoomLoadingImage extends StatelessWidget {
  final String url;

  const ZoomLoadingImage({this.url});

  @override
  Widget build(BuildContext context) {
    return ZoomableWidget(
        minScale: 0.3,
        maxScale: 2.0,
        // default factor is 1.0, use 0.0 to disable boundary
        panLimit: 0.8,
        child:TransitionToImage(
          image: AdvancedNetworkImage(
            this.url,
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
          fit: BoxFit.cover,
          placeholder: CircularProgressIndicator(),
          // This is default duration
          duration: Duration(milliseconds: 300),
        )
    );
  }
}