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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(post: updatedPost),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade900,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: updatedPost.id,
                          child: CachedNetworkImage(
                            imageUrl: updatedPost.mediaThumbUrl,
                            cacheKey: updatedPost.id.toString(),
                            memCacheWidth: 300,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 200,
                              color: Colors.grey.shade800,
                            ),
                            errorWidget: (_, __, ___) =>
                            const Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black87, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          AnimatedScale(
                            scale: updatedPost.isLiked ? 1.2 : 1.0,
                            duration:
                            const Duration(milliseconds: 200),
                            child: AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: updatedPost.isLiked
                                    ? Colors.red.withOpacity(0.15)
                                    : Colors.transparent,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: updatedPost.isLiked
                                      ? Colors.red
                                      : Colors.white54,
                                ),
                                onPressed: () {
                                  ref
                                      .read(feedProvider.notifier)
                                      .toggleLike(updatedPost.id);
                                },
                              ),
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
