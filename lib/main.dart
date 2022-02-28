import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'Widget/location.dart';
import 'marker_manager.dart';
void main() {

  runApp(const MyApp());
}
GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController? controller ;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> markers = {};
  late ValueChanged<bool> onChangeValueMarker;
  bool startMarker =false;
  bool startDrag=false;
    BitmapDescriptor? iconA;
    BitmapDescriptor? iconB;
  @override
  void initState() {
    super.initState();
    initialController();
    _changeValue();
  }
  void _changeValue (){
   onChangeValueMarker = (value){
     startMarker = value;
     setState(() {});
    };
  }
  Future<void> initialController ()async {
    controller = await _controller.future;

  }
  void markerBitmap()async{
    if(iconA==null )
      {
        ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
         await BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'assets/marker_A.png').then((value) {
              iconA=value;
              setState(() {});
         });
      }
    if(iconB== null)
      {
        ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
        await BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'assets/marker_B.png').then((value) {
             iconB = value;
              setState(() {});
        });
      }


  }
  @override
  Widget build(BuildContext context) {
  markerBitmap();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,

            onCameraMove: (position) {
              if(!startDrag){
                startDrag=true;
                setState(() {});
              }

            },
            onCameraIdle: () {
              if(startDrag)
                {
                  startDrag=false;
                  setState(() {});
                }
            },
            myLocationEnabled: true,

            zoomControlsEnabled: false,
            markers: markers,

            onTap: (argument) {

                  MarkerManager(controller: controller!,
                  latLng: argument,
                  marker: markers,
                  startMarker: startMarker,
                  valueChanged:onChangeValueMarker,
                  iconA: iconA!,
                  iconB: iconB!).beginMarker(
                      callBack: (){
                        setState(() {});
                      });


            },
            mapType: MapType.terrain,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Positioned(
              child: LocationWidget(startDrag: startDrag,)

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        label: Text('Get My Location'),
        icon: Icon(Icons.location_on_outlined),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
     LocationPermission  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied +++++++++++++++');
      }else{
        _changePosition();
      }
    }else {
      _changePosition();
    }

    // var status = await Permission.location.status;
    // if (status.isDenied) {
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.location,
    //   ].request();
    //   print(statuses[Permission.location]);
    //   if(statuses[Permission.location] == PermissionStatus.granted)
    //     {
    //       _changePosition();
    //     }
    // }else {
    //   _changePosition();
    // }
  }

  Future _changePosition()async
  {

    Position  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
         target: LatLng(position.latitude,position.longitude),
         zoom: 17,
          bearing: bearing,
          tilt: tilt,
        )
    ));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location = Lat:${position.latitude}   Long:${position.longitude} ")));
  }
}