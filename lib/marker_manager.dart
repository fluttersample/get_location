import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double zoom = 15;
double bearing = 10;
double tilt = 50;

class MarkerManager {
  final GoogleMapController controller;
  final Set<Marker> marker;
  final LatLng latLng;
  final ValueChanged<bool> valueChanged;
  final bool startMarker;

  final BitmapDescriptor iconA;
  final BitmapDescriptor iconB;

  MarkerManager({required this.controller,
    required this.marker,
    required this.latLng,
    required this.valueChanged,
    required this.startMarker,
    required this.iconA,
    required this.iconB,
  });


  Future<void> beginMarker({required Function callBack}) async {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng, zoom: zoom, tilt: tilt, bearing: bearing)));
    if (startMarker) {
      marker.add(Marker(
        markerId: const MarkerId('end'),
        position: latLng,
        infoWindow: const InfoWindow(
          title: 'Start Point',
          snippet: 'My Custom Subtitle',
        ),
        icon: iconB,
      ));


    } else {
      marker.add(Marker(
        markerId: const MarkerId('Begin'),
        position: latLng,
        infoWindow: const InfoWindow(
          title: 'End Point',
          snippet: 'My Custom Subtitle',
        ),
        icon: iconA,
      ));
      valueChanged(true);
    }


    callBack.call();
  }


}
