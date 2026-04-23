import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/models/post_model.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String imageUrl;
  bool isHighResLoading = false;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.post.mediaThumbUrl;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        imageUrl = widget.post.mediaMobileUrl;
      });
    });
  }

  Future<void> loadHighRes() async {
    if (isHighResLoading) return;

    setState(() => isHighResLoading = true);

    try {
      await precacheImage(
        NetworkImage(widget.post.mediaRawUrl),
        context,
      );

      if (!mounted) return;

      setState(() {
        imageUrl = widget.post.mediaRawUrl;
        isHighResLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isHighResLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load high-res image"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.post.id,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: CachedNetworkImage(
                  key: ValueKey(imageUrl),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: isHighResLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              onPressed: loadHighRes,
              icon: const Icon(Icons.download),
              label: const Text(
                "Download High-Res",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}