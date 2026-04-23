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
      return const Scaffold(
        body: Center(child: Text("No posts available")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Explore Feed")),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(feedProvider.notifier).refresh(),
        child: ListView.builder(
          controller: controller,
          addAutomaticKeepAlives: false,
          itemCount: length + 1,
          itemBuilder: (context, index) {
            if (index == length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
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