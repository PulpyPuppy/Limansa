import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_type.dart';
import '../models/story.dart';
import '../models/comment.dart';

class HnApiService {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  Future<List<Story>> fetchStories(FeedType type, {int limit = 20}) async {
    final url = Uri.parse('$_baseUrl/${type.endpoint}.json');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Couldn't fetch feed: ${type.label}");
    }

    final topIds = jsonDecode(response.body).take(limit).cast<int>();
    final stories = await Future.wait(topIds.map<Future<Story?>>(_fetchItem));

    return stories.whereType<Story>().toList();
  }

  Future<List<Comment>> fetchAllComments(List<int> kids) async {
    if (kids.isEmpty) {
      return [];
    }

    final comments = await Future.wait(kids.map<Future<Comment?>>(_fetchCommentItem));
    List<Comment> commentList = comments.whereType<Comment>().toList();
    List<Comment> kidComments = [];
    for (var comment in commentList) {
      kidComments.addAll(await fetchAllComments(comment.kids));
    }

    commentList.addAll(kidComments);
    return commentList;
  }

  Future<Story?> _fetchItem(int id) async {
    final url = Uri.parse('$_baseUrl/item/$id.json');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data == null) return null;

    return Story.fromJson(data as Map<String, dynamic>);
  }

  Future<Comment?> _fetchCommentItem(int id) async {
    final url = Uri.parse('$_baseUrl/item/$id.json');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data == null) return null;

    return Comment.fromJson(data as Map<String, dynamic>);
  }
}
