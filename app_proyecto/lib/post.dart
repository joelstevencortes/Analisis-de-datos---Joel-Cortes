class Post {
  String username;
  String imageUrl;
  int likes;
  List<String> comments;

  Post({
    required this.username,
    required this.imageUrl,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}