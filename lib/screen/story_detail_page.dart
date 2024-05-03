import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class StoryDetailPage extends StatefulWidget {
  final String storyId;

  const StoryDetailPage({super.key, required this.storyId});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          if (storyProvider.storyState == ApiState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (storyProvider.storyState == ApiState.error) {
            return Text('Error: ${storyProvider.errorMessage}');
          } else {
            return FutureBuilder<Story?>(
              future: storyProvider.getDetailStory(widget.storyId),
              builder: (context, snapshot) {
                final story = snapshot.data;
                if (story != null) {
                  return _buildPage(story, context);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPage(Story? story, BuildContext context) {
    if (story == null) {
      return const Text('Story not found');
    }
    if (story.lat != null && story.lon != null) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildMaps(LatLng(story.lat ?? 0.0, story.lon ?? 0.0)),
                const Positioned(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: 24,
                  child: SizedBox.shrink(),
                ),
                _buildBackButton(context),
              ],
            ),
          ),
          _buildContent(context, story)
        ],
      );
    } else {
      return Stack(
        children: [
          const Positioned(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 24,
            child: SizedBox.shrink(),
          ),
          _buildContent(context, story),
          _buildBackButton(context),
        ],
      );
    }
  }

  GoogleMap _buildMaps(LatLng latLng) {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        zoom: 18,
        target: latLng,
      ),
      markers: markers,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        final info = await geo.placemarkFromCoordinates(
            latLng.latitude, latLng.longitude);

        final place = info[0];
        final street = place.street!;
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

        setState(() {
          placemark = place;
        });

        defineMarker(latLng, street, address);

        setState(() {
          mapController = controller;
        });
      },
      onLongPress: (LatLng latLng) {
        //onLongPressGoogleMap(latLng);
      },
    );
  }

  void defineMarker(LatLng latLng, String? street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street ?? '',
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 40),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: IconButton(
            onPressed: () {
              // Add your action here
              context.goNamed('home');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getInfoLocation(Story? story) async {
    final info = await geo.placemarkFromCoordinates(
        story?.lat ?? 0.0, story?.lon ?? 0.0);

    final place = info.isNotEmpty ? info[0] : null;
    final address = place != null
        ? '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}'
        : '';
    return address;
  }

  SizedBox _buildContent(BuildContext context, Story story) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: story.photoUrl != null
                      ? Image.network(
                          story.photoUrl!,
                          height: 200,
                          width: 350,
                          fit: BoxFit.fitWidth,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                story.name ?? '',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                story.description ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: getInfoLocation(story),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading ....");
                        } else if (snapshot.hasError) {
                          return const Text('No Found Location');
                        } else {
                          final locationInfo = snapshot.data ?? '';
                          return Text(
                            locationInfo,
                            style: const TextStyle(fontSize: 14.0),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
