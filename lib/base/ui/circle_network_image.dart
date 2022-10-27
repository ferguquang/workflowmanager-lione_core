import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleNetworkImage extends StatelessWidget {
  String url;
  double width = 72;
  double height = 72;
  double size;

  CircleNetworkImage({@required this.url, this.height, this.width, this.size}) {
    if (size != null) {
      height = size;
      width = size;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Icon(
        Icons.account_circle,
        size: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) {
        return Icon(
          Icons.account_circle,
          size: width,
          color: Colors.grey,
        );
      },
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: width,
          width: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        );
      },
    );
  }
}
