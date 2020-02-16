import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';

class ImageView extends StatelessWidget {
  final String url;
  final num width;
  final num height;
  ImageView({@required this.url, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        Widget loader;
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            loader = Center(
              child: CupertinoActivityIndicator(),
            );
            break;
          case LoadState.completed:
            loader = ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: width,
              height: height,
            );
            break;
          default:
        }
        return loader;
      },
    );
  }
}
