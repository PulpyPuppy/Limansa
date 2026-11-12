import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/comment.dart';
import '../services/hn_api_service.dart';

class LimansaComments extends StatefulWidget {
  final Story story;

  const LimansaComments({
    super.key,
    required this.story,
  });

  @override
  State<LimansaComments> createState() => _LimansaCommentsState();
}

class _LimansaCommentsState extends State<LimansaComments> {
  final _api = HnApiService();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _api.fetchAllComments(widget.story.kids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.story.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FutureBuilder<List<Comment>>(
        future: _commentsFuture,
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
                        _commentsFuture = _api.fetchAllComments(widget.story.kids);
                      });
                    },
                    child: const Text('Repeat'),
                  ),
                ],
              ),
            );
          }

          final comments = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _commentsFuture = _api.fetchAllComments(widget.story.kids);
              });
              await _commentsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: comments.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final comment = comments[index];
                final parent = comments
                          .where((c) => c.id == comment.parent)
                          .firstOrNull?.by ?? widget.story.by;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('By ${comment.by} to ${parent}'),
                  subtitle: Text('${comment.text}'),
                  trailing: Text('${comment.time}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
