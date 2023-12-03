import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitter/Database.dart';
import 'package:twitter/NewTweetPage.dart';
import 'package:twitter/Tweet.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'NewReplyPage.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}):super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
 var formKey = GlobalKey<FormState>();
 int isLiked = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      // Image.file(File('DirectoryLocation/imageName.jpg')
      appBar: AppBar(title: SizedBox(child: Image.asset('assets/logo.png'), width: 40, height: 40),
      actions: [IconButton(padding:EdgeInsets.only(right:30),icon: Icon(Icons.send),onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return NewTweetPage();
                      }));
                    },)],
                    automaticallyImplyLeading: false,),

      body: FutureBuilder<List<Tweet>>(
        future: DatabaseHelper.instance.getAllTweets(),
        builder:(BuildContext context, AsyncSnapshot<List<Tweet>> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
                 }
            if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
                }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No Records Found'));
                } 
            else{

              List<Tweet> tweets = snapshot.data!;
              tweets = tweets.reversed.toList(); // newest tweets to be seen first


              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: ((context, index){
                    Tweet t = tweets[index];
                        return Container(
                          margin: EdgeInsets.only(top: 35),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:Color(Random().nextInt(0xffffffff)), // sets random color for each usernames profile pic default
                      child:
                      Text(t.userShortName.substring(0,1).toUpperCase(),
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                      radius: 25.0,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${t.userLongName.toString()}  @${t.userShortName.toString()}',
                            style: GoogleFonts.roboto(fontSize: 18,fontWeight:FontWeight.bold),
                          ),
                          SizedBox(height:8),
                    
                          Text(t.description, style: GoogleFonts.roboto(fontSize: 18)),
                          t.imageURL != null && t.imageURL.isNotEmpty
                          ? Image.network(
                              t.imageURL,
                              width: double.infinity,
                            )
                          : Container(),

                          SizedBox(height:20),
                          Text(t.timeString.toString().substring(0,5), style:TextStyle(fontSize: 16)),
                          SizedBox(height:5),

                         
                          Row(
                            children: [
                              IconButton(
                              icon: Icon(Icons.favorite),
                              color: isLiked == 1 ? Colors.red : Colors.black,
                              onPressed: () {
                                setState(() {

                                  isLiked = 1 - isLiked;
                                  
                                });
            
                              },
                            ),
                              
                              Text('${t.numLikes}'),
                              SizedBox(width:15),
                              IconButton(icon:Icon(Icons.repeat), onPressed:(){},),
                              Text('${t.numRetweets}'),
                              SizedBox(width:15),
                              IconButton(icon: Icon(Icons.comment), onPressed:(){
                                   Navigator.of(context)
                                   .push(MaterialPageRoute(builder: (_) {
                             return NewReplyPage(originalTweet: t);
                      }));
                              }),
                              Text('${t.numComments}'),
                              Text(t.id.toString()),
                            ],
                          ),

                          // FutureBuilder<List<Tweet>>(future:
                          //  DatabaseHelper.instance.getCommentsForTweet(t.id), 
                          //  builder:(BuildContext context, AsyncSnapshot<List<Tweet>> snapshot){
                          //    if (snapshot.connectionState == ConnectionState.waiting) {
                          //         return Center(child: CircularProgressIndicator());
                          //       }
                          //    if (snapshot.hasError) {
                          //     return Text("Error: ${snapshot.error}");
                          //   } 
                          //   if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                          //         return Container(); // No comments
                          //       } else {
                          //         List<Tweet> comments = snapshot.data!;
                          //         comments = comments.where((comment) => comment.id != t.id).toList();
                          //         return Column(
                          //           children: comments.map((comment) {
                          //             return Container(
                          //               margin: EdgeInsets.only(left: 50, top: 20),
                          //               child: Column(
                          //                  crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                            Text(comment.description, style: TextStyle(fontSize: 16)), 
                          //                 ],
                                            
                          //               ),
                          //             );
                          //           }).toList(),
                          //         );


                          //  }})


                        ],
                      ),
                    ),
                  
                    IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                  
                      },
                    ),
                  ],
                ),
              );
             }

                )
              ));
            }
        }
      )

    );
  }
}