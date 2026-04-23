import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchPosts(int limit, int offset) async {
    final res = await client
        .from('posts')
        .select()
        .range(offset, offset + limit - 1);

    return res;
  }

  Future<void> toggleLike(String postId) async {
    await client.rpc('toggle_like', params: {
      'p_post_id': postId,
      'p_user_id': 'user_123',
    });
  }
}