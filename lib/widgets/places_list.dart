import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/places_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;
  @override
  Widget build(context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No item here',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PlacesDetail(place: places[index]);
                      }),
                    );
                  },
                  leading: CircleAvatar(  // hình tròn avatar
                    radius: 26,  
                    backgroundImage: FileImage(places[index].image),  // FileImage là provider image
                  ),
                  title: Text(
                    places[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
