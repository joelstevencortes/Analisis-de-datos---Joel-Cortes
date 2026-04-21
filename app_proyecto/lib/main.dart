import 'package:flutter/material.dart';
import 'post.dart';
import 'post_widget.dart';

void main() {
  runApp(FeedJKJApp());
}

class FeedJKJApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1877F2),
        scaffoldBackgroundColor: Color(0xFFF5F9FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      home: LoginScreen(),
    );
  }
}

////////////////////////////////////////////////////
/// LOGIN
////////////////////////////////////////////////////

class LoginScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF4FF),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("FeedJKJ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (controller.text.isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(username: controller.text),
                    ),
                  );
                },
                child: Text("Entrar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////
/// HOME
////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  int currentIndex = 0;

 void showAddPostDialog() {
  TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Nueva publicación"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Pega URL de la imagen",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String url = controller.text.trim();

            if (url.isEmpty) return;

            if (!url.startsWith("http")) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("URL no válida")),
              );
              return;
            }

            setState(() {
              posts.insert(
                0,
                Post(
                  username: widget.username,
                  imageUrl: url,
                ),
              );
            });

            Navigator.pop(context);
          },
          child: Text("Publicar"),
        ),
      ],
    ),
  );
}

  Widget buildFeed() {
    return Scaffold(
      appBar: AppBar(title: Text("FeedJKJ")),
      body: posts.isEmpty
          ? Center(child: Text("No hay publicaciones"))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (_, i) => PostWidget(post: posts[i]),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1877F2),
        onPressed: showAddPostDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

 Widget buildProfile() {
  // Filtrar solo mis posts
  List<Post> myPosts = posts
      .where((post) => post.username == widget.username)
      .toList();

  return Scaffold(
    appBar: AppBar(title: Text("Perfil")),
    body: Column(
      children: [
        SizedBox(height: 20),

        CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFF1877F2),
          child: Text(
            widget.username[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        SizedBox(height: 10),

        // Nombre de usuario
        Text(
          widget.username,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 20),

        // Si no hay fotos
        if (myPosts.isEmpty)
          Expanded(
            child: Center(child: Text("No tienes publicaciones")),
          )
        else
          // Galería tipo Instagram
          Expanded(
            child: GridView.builder(
              itemCount: myPosts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (_, i) {
                return Image.network(
                myPosts[i].imageUrl,
                fit: BoxFit.cover,
              );
              },
            ),
          ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0 ? buildFeed() : buildProfile(),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF1877F2),
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}