import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:flutter_blog/views/create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();

  Stream? blogsStream;

  //Function to retrieve data from Firebase

  Widget blogsList() {
    return Container(
      child: blogsStream != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: blogsStream,
                    builder: (context, snapshot) {
                      return ListView?.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            (snapshot.data! as QuerySnapshot).docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BlogsTile(
                            imgUrl: (snapshot.data! as QuerySnapshot)
                                .docs[index]['imgUrl'],
                            title: (snapshot.data! as QuerySnapshot).docs[index]
                                ['title'],
                            description: (snapshot.data! as QuerySnapshot)
                                .docs[index]['description'],
                            authorName: (snapshot.data! as QuerySnapshot)
                                .docs[index]['authorName'],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        toolbarHeight: 60.0,
        title: Text(
          'BLOG APP',
          style: TextStyle(fontSize: 22.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: blogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl = "N/A", title = "N/A", description = "N/A", authorName = "N/A";
  BlogsTile({
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: CachedNetworkImage(
              imageUrl: imgUrl as String,
              height: 250.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  authorName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
