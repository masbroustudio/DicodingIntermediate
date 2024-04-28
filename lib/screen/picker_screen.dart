import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:youstoryapp02/utils/location_handler.dart';
import 'package:youstoryapp02/utils/placemark_widget.dart';

class PickerScreen extends StatefulWidget {
  const PickerScreen({super.key});

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  final LocationHandler _locationHandler = LocationHandler();
  LatLng inputLang = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            _buildMaps(),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  onMyLocationButtonPress();
                },
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Column(
                  children: [
                    PlacemarkWidget(
                      placemark: placemark!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () {
                              context.goNamed('add',
                                  extra: LatLng(
                                      inputLang.latitude, inputLang.longitude));

                              showInputSnackBar(context, inputLang);
                            },
                            child: const Text(
                              'Pilih',
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showInputSnackBar(BuildContext context, LatLng inputLang) {
    String message = (inputLang.latitude != 0.0 || inputLang.longitude != 0.0)
        ? 'Input Berhasil'
        : 'Input Gagal';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  GoogleMap _buildMaps() {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        zoom: 18,
        target: inputLang,
      ),
      markers: markers,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        final info = await geo.placemarkFromCoordinates(
            inputLang.latitude, inputLang.longitude);

        final place = info[0];
        final street = place.street!;
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

        setState(() {
          placemark = place;
        });

        defineMarker(inputLang, street, address);

        setState(() {
          mapController = controller;
        });
      },
      onLongPress: (LatLng latLng) {
        onLongPressGoogleMap(latLng);
      },
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      inputLang = latLng;

      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress() async {
    final LatLng? latLng = await _locationHandler.getCurrentLocation();

    if (latLng != null) {
      final info = await _locationHandler.getPlacemark(
          latLng.latitude, latLng.longitude);
      final place = info!;
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      setState(() {
        inputLang = latLng;
        placemark = place;
      });

      defineMarker(latLng, street, address);

      mapController.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }
  }
}
