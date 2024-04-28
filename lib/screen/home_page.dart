import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youstoryapp02/data/db/auth_repository.dart';
import 'package:youstoryapp02/data/model/story.dart';
import 'package:youstoryapp02/provider/story_provider.dart';
import 'package:youstoryapp02/utils/app_drawer.dart';
import 'package:youstoryapp02/utils/favorite_widget.dart';

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
                      context
                          .read<StoryProvider>()
                          .resetPagination(); // Reset pagination
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

  Widget _buildStoryList(BuildContext context, StoryProvider storyProvider) {
    if (storyProvider.isFetching || storyProvider.storyList.isEmpty == true) {
      return const Text('No stories available');
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
                  return _buildStoryCard(context, story);
                } else {
                  // This is the loading indicator at the end of the list
                  return _buildLoadingIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, Story story) {
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
              subtitle: Text(
                formatDateTime(parseDateTime('${story.createdAt}')),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FavoriteButton(),
                      IconButton(
                        icon: const Icon(Icons.comment),
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
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
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

  String formatDateTime(DateTime? dateTime) {
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

    // Parse the ISO 8601 formatted string
    final dateTime = DateTime.tryParse(dateTimeString);

    return dateTime;
  }
}
