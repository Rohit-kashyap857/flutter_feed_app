import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/post_model.dart';
import '../provider/feed_provider.dart';
import '../screens/details_screen.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedPost = ref.watch(
      feedProvider.select(
            (list) => list.firstWhere((p) => p.id == post.id),
      ),
    );

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(post: updatedPost),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  offset: Offset(0, 10),
                  color: Color(0x26000000),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: updatedPost.id,
                      child: CachedNetworkImage(
                        imageUrl: updatedPost.mediaThumbUrl,
                        cacheKey:
                        updatedPost.id.toString(),
                        memCacheWidth: 300,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: 220,
                          color: Colors.grey,
                        ),
                        errorWidget: (_, __, ___) =>
                        const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite,
                                  size: 18,
                                  color: Colors.redAccent),
                              const SizedBox(width: 6),
                              Text(
                                "${updatedPost.likeCount}",
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          AnimatedScale(
                            scale: updatedPost.isLiked
                                ? 1.2
                                : 1.0,
                            duration: const Duration(
                                milliseconds: 200),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: updatedPost.isLiked
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                ref
                                    .read(feedProvider
                                    .notifier)
                                    .toggleLike(
                                    updatedPost.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}