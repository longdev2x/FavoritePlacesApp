import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

class PlacesDetail extends StatelessWidget {
  const PlacesDetail({super.key, required this.place});
  final Place place;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(place.image,
              fit: BoxFit.cover, height: double.infinity, width: double.infinity),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              child: Text(
                'No thing here !!! ',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
