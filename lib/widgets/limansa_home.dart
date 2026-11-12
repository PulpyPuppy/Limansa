import 'package:flutter/material.dart';
import '../widgets/limansa_footer.dart';
import '../widgets/limansa_bar.dart';
import '../widgets/limansa_feed.dart';
import '../models/feed_type.dart';

class LimansaHome extends StatefulWidget {
  const LimansaHome({super.key});
  
  @override
  State<LimansaHome> createState() => _HomeState();
}

class _HomeState extends State<LimansaHome> {
  FeedType _feed = FeedType.newF;
  final Set<FeedType> _initializedFeeds = {FeedType.newF};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LimansaBar(),
      body: IndexedStack(
        index: _feed.index,
        children: FeedType.values.map((type) {
          if (!_initializedFeeds.contains(type)) {
            return const SizedBox.shrink();
          }
          return LimansaFeed(type: type);
        }).toList(),
      ),
      bottomNavigationBar: LimansaFooter(
        feed: _feed,
        onSelect: (newFeed) {
          setState(() {
            _feed = newFeed;
            _initializedFeeds.add(newFeed);
          });
        },
      ),
    );
  }
}
