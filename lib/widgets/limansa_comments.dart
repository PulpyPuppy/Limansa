import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/comment.dart';
import '../services/hn_api_service.dart';

class CommentsState {
  final bool isLoading;
  final List<Comment> comments;
  final String? error;

  const CommentsState({
    this.isLoading = false,
    this.comments = const [],
    this.error,
  });
}

class CommentsCubit extends Cubit<CommentsState> {
  final _api = HnApiService();

  CommentsCubit() : super(const CommentsState(isLoading: true));

  Future<void> loadComments(List<int> kids) async {
    emit(const CommentsState(isLoading: true));

    try {
      final result = await _api.fetchAllComments(kids);
      emit(CommentsState(comments: result));
    } catch (e) {
      emit(CommentsState(error: e.toString()));
    }
  }
}

class LimansaComments extends StatelessWidget {
  final Story story;

  const LimansaComments({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentsCubit()..loadComments(story.kids),
      child: Scaffold(
        appBar: AppBar(
          title: Text(story.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: BlocBuilder<CommentsCubit, CommentsState>(
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
                      onPressed: () => context.read<CommentsCubit>().loadComments(story.kids),
                      child: const Text('Repeat'),
                    ),
                  ],
                ),
              );
            }

            final comments = state.comments;
            
            return RefreshIndicator(
              onRefresh: () => context.read<CommentsCubit>().loadComments(story.kids),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: comments.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final parent = comments
                            .where((c) => c.id == comment.parent)
                            .firstOrNull?.by ?? story.by;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${comment.by} -> $parent'),
                    subtitle: Text('${comment.text}'),
                    trailing: Text('${comment.time}'),
                  );
                },
              ),
            );
          },
        ), // пиздец что это такое
      ),
    );
  }
}
