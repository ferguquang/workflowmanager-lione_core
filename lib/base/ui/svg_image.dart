import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImage extends StatelessWidget {
  String svgName;
  Function onTap;

  SVGImage({@required this.svgName, this.onTap});

  _icon() {
    return SvgPicture.asset(
      'assets/svgs/$svgName.svg',
      semanticsLabel: svgName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return (onTap != null)
        ? InkWell(
            onTap: () {
              onTap();
            },
            child: _icon(),
          )
        : _icon();
  }
}
