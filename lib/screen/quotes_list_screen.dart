import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';
import '../routes/page_manager.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() toFormScreen;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.toFormScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),

        // Tambahkan ikon pada halaman QuotesListScreen
        actions: [
          IconButton(
            // Beri aksi untuk bernavigasi ke halaman FormScreen
            onPressed: () async {
              final scaffoldMessengerState = ScaffoldMessenger.of(context);
              toFormScreen();
              final dataString =
                  await context.read<PageManager>().waitForResult();
              scaffoldMessengerState.showSnackBar(
                SnackBar(content: Text("My name is $dataString")),
              );
            },
            icon: const Icon(Icons.quiz),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            )
        ],
      ),
    );
  }
}
