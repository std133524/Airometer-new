import 'dart:async';

import 'package:air_quality_app/widgets/places.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

class Deley {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Deley({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(microseconds: milliseconds), action);
  }
}

class LocationApi extends ChangeNotifier {
  List<Place> places = [];

  var addressController = TextEditingController();

  final _deley = Deley(milliseconds: 500);

  final _controller = StreamController<List<Place>>.broadcast();
  Stream<List<Place>> get controllerOut =>
      _controller.stream.asBroadcastStream();

  StreamSink<List<Place>> get controllerIn => _controller.sink;

  addPlace(Place place) {
    places.add(place);
    controllerIn.add(places);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  handleSearch(String query) async {
    if (query.length > 2) {
      _deley.run(() async {
        try {
          List<Location> locations = await locationFromAddress(query);
          locations.forEach((location) async {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
                location.latitude, location.longitude);
            placeMarks.forEach((placeMark) {
              addPlace(Place(
                city: placeMark.locality!,
                state: placeMark.administrativeArea!,
                country: placeMark.country!,
              ));
            });
          });
        } on Exception catch (e) {
          print(e);
        }
      });
    } else {
      places.clear();
    }
  }
}
