class Post {
  final String id;
  final String mediaThumbUrl;
  final String mediaMobileUrl;
  final String mediaRawUrl;
  final int likeCount;
  final bool isLiked;

  Post({
    required this.id,
    required this.mediaThumbUrl,
    required this.mediaMobileUrl,
    required this.mediaRawUrl,
    required this.likeCount,
    this.isLiked = false,
  });

  Post copyWith({
    bool? isLiked,
    int? likeCount,
  }) {
    return Post(
      id: id,
      mediaThumbUrl: mediaThumbUrl,
      mediaMobileUrl: mediaMobileUrl,
      mediaRawUrl: mediaRawUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(), // UUID → string
      mediaThumbUrl: json['media_thumb_url'] ?? '',
      mediaMobileUrl: json['media_mobile_url'] ?? '',
      mediaRawUrl: json['media_raw_url'] ?? '',
      likeCount: json['like_count'] ?? 0,
    );
  }
}