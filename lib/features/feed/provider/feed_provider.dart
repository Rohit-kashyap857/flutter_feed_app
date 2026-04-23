import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/post_model.dart';
import '../../../core/services/supabase_service.dart';

final feedProvider =
StateNotifierProvider<FeedNotifier, List<Post>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<List<Post>> {
  FeedNotifier() : super([]);

  final service = SupabaseService();

  int offset = 0;
  bool isLoading = false;

  final Map<String, bool> _lockMap = {};

  Future<void> loadMore() async {
    if (isLoading) return;

    isLoading = true;

    try {
      final res = await service.fetchPosts(10, offset);

      final newPosts =
      res.map((e) => Post.fromJson(e)).toList();

      final existingIds = state.map((e) => e.id).toSet();

      final filteredPosts = newPosts
          .where((p) => !existingIds.contains(p.id))
          .toList();

      if (!mounted) return;

      state = [...state, ...filteredPosts];

      offset += 10;
    } catch (e) {
      print("FETCH ERROR: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    offset = 0;
    state = [];
    await loadMore();
  }


  void toggleLike(String postId) {
    if (_lockMap[postId] == true) return;

    _lockMap[postId] = true;

    final oldState = List<Post>.from(state);

    state = [
      for (final post in state)
        if (post.id == postId)
          post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.isLiked
                ? post.likeCount - 1
                : post.likeCount + 1,
          )
        else
          post
    ];

    _sendLike(postId, oldState);
  }

  Future<void> _sendLike(
      String postId, List<Post> oldState) async {
    try {
      await service.toggleLike(postId);
    } catch (e) {
      print("LIKE ERROR: $e");

      if (!mounted) return;

      state = oldState;
    } finally {
      _lockMap[postId] = false;
    }
  }
}