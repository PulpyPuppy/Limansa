import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/hn_api_service.dart';
import '../widgets/limansa_comments.dart';
import '../models/feed_type.dart';
import '../models/story.dart';
import '../utils/utils.dart' as utils;

class FeedState {
  final bool isLoading;
  final List<Story> stories;
  final String? error;

  const FeedState({
    this.isLoading = false,
    this.stories = const [],
    this.error,
  });
}

class FeedCubit extends Cubit<FeedState> {
  final _api = HnApiService();

  FeedCubit() : super(const FeedState(isLoading: true));

  Future<void> loadStories(FeedType type) async {
    emit(const FeedState(isLoading: true));

    try {
      final result = await _api.fetchStories(type);
      emit(FeedState(stories: result));
    } catch (e) {
      emit(FeedState(error: e.toString()));
    }
  }
}

class LimansaFeed extends StatelessWidget {
  final FeedType type;

  const LimansaFeed({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedCubit()..loadStories(type),
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Couldn\'t load stuff: ${state.error}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<FeedCubit>().loadStories(type),
                    child: const Text('Repeat'),
                  ),
                ],
              ),
            );
          }

          final stories = state.stories;

          return RefreshIndicator(
            onRefresh: () => context.read<FeedCubit>().loadStories(type),
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
                        const TextSpan(text: ' | '),
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
        },
      ), // Пиздец что это за кошмар
    );
  }
}
