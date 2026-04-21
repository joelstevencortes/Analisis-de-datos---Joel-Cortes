import 'package:flutter/material.dart';
import 'post.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController commentController = TextEditingController();

  void addLike() {
    setState(() {
      widget.post.likes++;
    });
  }

  void addComment() {
    if (commentController.text.isEmpty) return;

    setState(() {
      widget.post.comments.add(commentController.text);
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF1877F2),
              child: Text(
                widget.post.username[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(widget.post.username),
          ),

          Image.network(widget.post.imageUrl),

          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: addLike,
              ),
              Text("${widget.post.likes} likes"),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.post.comments
                  .map((c) => Text("• $c"))
                  .toList(),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Comentario...",
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: addComment,
              )
            ],
          )
        ],
      ),
    );
  }
}