import 'package:flutstory/data/providers/addstory_provider.dart';
import 'package:flutstory/data/providers/allstory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/local/app_preferences.dart';
import '../data/network/response_call.dart';
import '../widgets/language_selector.dart';
import '../widgets/list_story_loading.dart';
import '../widgets/story_card.dart';
import 'addstory_page.dart';
import 'loginstory_page.dart';

class HomestoryPage extends StatefulWidget {
  static const path = '/stories';

  const HomestoryPage({super.key});

  @override
  State<HomestoryPage> createState() => _HomestoryPageState();
}

class _HomestoryPageState extends State<HomestoryPage> {
  _initLoadData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      context.read<AllstoryProvider>().getAllStories();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<AllstoryProvider>().getAllStories();
  }

  void _handleNavigateNewStory() {
    context.pushNamed(AddstoryPage.path);
  }

  void _handleLogout() async {
    await AppPreferences.clearSession();
    if (mounted) {
      context.pushReplacementNamed(LoginstoryPage.path);
    }
  }

  @override
  void initState() {
    _initLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.textStoryList),
        actions: [
          const LanguageSelector(),
          IconButton(onPressed: _handleLogout, icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNavigateNewStory,
        child: const Icon(Icons.add),
      ),
      body: Consumer<AllstoryProvider>(
        builder: (context, value, child) {
          if (value.responseCall.status == Status.loading) {
            return const ListStoryLoading();
          }

          if (value.responseCall.status == Status.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.responseCall.message.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: const Text("Refresh"),
                    )
                  ],
                ),
              ),
            );
          }

          if ((value.responseCall.data ?? []).isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.textEmptyStory,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: const Text("Refresh"),
                    )
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.blue,
            onRefresh: _onRefresh,
            child: ListView.separated(
              itemCount: value.responseCall.data!.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final story = value.responseCall.data![index];

                return StoryCard(story: story);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }
}
