import 'package:flutter/material.dart';
import 'package:insta_clone/features/home/presentation/components/my_drawer.dart';
import 'package:insta_clone/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload new posts
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPostPage()),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // drawer
      drawer: MyDrawer(),
    );
  }
}
