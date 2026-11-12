import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/limansa_comments.dart';
import '../models/story.dart';
import '../models/feed_type.dart';
import '../services/hn_api_service.dart';
import '../utils/utils.dart' as utils;

class LimansaFeed extends StatefulWidget {
  final FeedType type;

  const LimansaFeed({
    super.key,
    required this.type,
  });

  @override
  State<LimansaFeed> createState() => _LimansaFeedState();
}

class _LimansaFeedState extends State<LimansaFeed> {
  final _api = HnApiService();
  late Future<List<Story>> _storiesFuture;

  @override
  void initState() {
    super.initState();
    _storiesFuture = _api.fetchStories(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Story>>(
      future: _storiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Couldn\'t load stuff: ${snapshot.error}'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _storiesFuture = _api.fetchStories(widget.type);
                    });
                  },
                  child: const Text('Repeat'),
                ),
              ],
            ),
          );
        }

        final stories = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _storiesFuture = _api.fetchStories(widget.type);
            });
            await _storiesFuture;
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stories.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final story = stories[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: InkWell(
                  onTap: () {
                    utils.openUrl(story.url ?? '');
                  },
                  child: Text(story.title),
                ),
                subtitle: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${story.score} points | '),
                      TextSpan(
                        text: 'by ${story.by}',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {},
                      ),
                      TextSpan(text: ' | '),
                      TextSpan(
                        text: '${story.descendants} comments',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LimansaComments(story: story),
                              ),
                            );
                          },
                      ),
                      TextSpan(text: ' | ${story.time}'),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }, // Пиздец что это за кошмар
    );
  }
}
