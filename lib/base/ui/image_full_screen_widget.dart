import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';

class ImageFullScreenWidget extends StatelessWidget {
  String url;

  ImageFullScreenWidget(this.url);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: CachedNetworkImage(
          errorWidget: (context, url, erro) {
            return Icon(Icons.error);
          },
          imageUrl:  url,
          imageBuilder: (context, imageProvider) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
