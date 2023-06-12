import 'dart:async';

import 'package:final_project/helper/location_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class mapscreen extends StatefulWidget {
  const mapscreen({super.key});

  @override
  State<mapscreen> createState() => _mapscreenState();
}

class _mapscreenState extends State<mapscreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    zoom: 14.4746,
  );



       static Marker _kGooglePlexMarker =  Marker(
    markerId: MarkerId('_kgooglePlex'),
    infoWindow: InfoWindow(title: 'googlePlex'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(position!.latitude, position!.longitude),
  );

  static Position? position;

  Future<void> getMyCurrentLocation() async {
    await LocationHelper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition();

    setState(() {
      _kGooglePlexMarker = Marker(
        markerId: const MarkerId('_kgooglePlex'),
        infoWindow: const InfoWindow(title: 'current location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),

        position: LatLng(position!.latitude, position!.longitude),
      );
    });
    // });
  }

  Future<void> gotoMyCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

 @override
  void initState() {
    super.initState();

    getMyCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
         myLocationButtonEnabled:true,
         markers: {_kGooglePlexMarker},

         onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

        },
      ),

    );
  }

  }
