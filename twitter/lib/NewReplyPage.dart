import 'package:flutter/material.dart';
import 'package:twitter/Tweet.dart';
import 'package:twitter/Database.dart';
import 'package:intl/intl.dart';


class NewReplyPage extends StatefulWidget {
  final Tweet originalTweet;

  const NewReplyPage({Key? key, required this.originalTweet}) : super(key: key);

  @override
  _NewReplyPageState createState() => _NewReplyPageState();
}

class _NewReplyPageState extends State<NewReplyPage> {
  var formKey = GlobalKey<FormState>();
  late String replyText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply to Tweet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Replying to: ${widget.originalTweet.userShortName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                autofocus: true,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  hintText: 'Your reply...',
                ),
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return 'Enter your reply!';
                  }
                  replyText = text;
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        DateTime current = DateTime.now();
                        String stringFormatTime = DateFormat('kk:mm:ss \n EEE d MMM').format(current);
                        Tweet reply = Tweet(
                          userShortName: 'YourUsername', // Set the user's username
                          userLongName: 'YourName', // Set the user's name
                          timeString: stringFormatTime,
                          description: replyText,
                          imageURL: '', // You may add image URL if needed
                          numComments: 0,
                          numRetweets: 0,
                          numLikes: 0,
                          isLiked: 0,
                        );
                        int result = await DatabaseHelper.instance.insertComment(reply);
                        if (result > 0) {
                          // Update the comment count in the original tweet
                          await DatabaseHelper.instance.incrementCommentCount(widget.originalTweet.id);
                          Navigator.of(context).pop(); // Close the reply page
                        }
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
