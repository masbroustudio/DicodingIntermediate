import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youstoryapp02/data/db/auth_repository.dart';
import 'package:youstoryapp02/data/model/story.dart';
import 'package:youstoryapp02/provider/story_provider.dart';
import 'package:youstoryapp02/utils/app_drawer.dart';
import 'package:youstoryapp02/widget/favorite_widget.dart';
import 'package:geocoding/geocoding.dart' as geo;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storyProvider = context.read<StoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (!storyProvider.isFetching && storyProvider.hasMorePages) {
          storyProvider.getAllStories(page: storyProvider.pageItems);
        }
      }
    });

    Future.microtask(() async => storyProvider.getAllStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.grey,
        title: FutureBuilder<String?>(
          future: AuthRepository().getName(),
          builder: (context, snapshot) {
            return Text(
              'Hello, ${snapshot.data ?? ''}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            );
          },
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  bool? val = await context.pushNamed('add');
                  if (val == true) {
                    if (!context.mounted) return;
                    setState(() {
                      context.read<StoryProvider>().resetPagination();
                      context.read<StoryProvider>().getAllStories();
                    });
                  }
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: Consumer<StoryProvider>(
          builder: (context, storyProvider, child) {
            return _buildStoryList(context, storyProvider);
          },
        ),
      ),
      drawer: const AppDrawer(),
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

  Widget _buildStoryList(BuildContext context, StoryProvider storyProvider) {
    if (storyProvider.isFetching || storyProvider.storyList.isEmpty == true) {
      return const Text('Loading... No stories available');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StoryProvider>().getAllStories(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: storyProvider.storyList.length +
                  (storyProvider.hasMorePages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < storyProvider.storyList.length) {
                  final story = storyProvider.storyList[index];
                  return _wdHomeStoryCard(context, story);
                } else {
                  return _buildLoadingIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _wdHomeStoryCard(BuildContext context, Story story) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                story.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                story.photoUrl ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const FavoriteButton(),
                      IconButton(
                        icon: const Icon(Icons.expand_circle_down_rounded),
                        onPressed: () async {
                          if (context.mounted) {
                            context.goNamed('detail',
                                pathParameters: {'id': story.id ?? ''});
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatDateTime(parseDateTime('${story.createdAt}'),
                                style: const TextStyle(fontSize: 6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        const FittedBox(
                          child: Icon(
                            Icons.list,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 2.0),
                        Expanded(
                          child: Text(
                            story.description ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        const FittedBox(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 2.0),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String formatDateTime(DateTime? dateTime, {required TextStyle style}) {
    if (dateTime == null) {
      return 'No Date Available';
    }

    final formattedDateTime =
        DateFormat('MMM dd, yyyy HH:mm a').format(dateTime);

    return formattedDateTime;
  }

  DateTime? parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }

    final dateTime = DateTime.tryParse(dateTimeString);

    return dateTime;
  }
}
