import 'package:flutter/material.dart';

class CarouselView extends StatefulWidget {
  final List<String> imageUrls;
  final int currentId;

  const CarouselView({
    Key? key,
    required this.imageUrls,
    required this.currentId,
  }) : super(key: key);

  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(
          initialPage: widget.currentId,
          keepPage: true,
          viewportFraction: 1,
        ),
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, i) {
          return Center(
            child: Image.network(
              widget.imageUrls[i],
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
