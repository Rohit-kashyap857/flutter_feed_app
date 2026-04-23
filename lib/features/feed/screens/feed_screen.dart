import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<FeedScreen> createState() =>
      _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final controller = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedProvider.notifier).loadMore();
    });

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        if (!_isFetchingMore) {
          _isFetchingMore = true;

          ref
              .read(feedProvider.notifier)
              .loadMore()
              .then((_) {
            _isFetchingMore = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);
    final length = posts.length;
    if (length == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.photo, size: 60, color: Colors.white24),
              SizedBox(height: 12),
              Text(
                "No posts available",
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Feed",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: () =>
            ref.read(feedProvider.notifier).refresh(),

        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          addAutomaticKeepAlives: false,
          itemCount: length + 1,

          itemBuilder: (context, index) {
            if (index == length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Loading more...",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }

            final post = ref.watch(
              feedProvider.select((list) => list[index]),
            );

            return PostCard(post: post);
          },
        ),
      ),
    );
  }
}
