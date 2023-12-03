class Tweet{
  late dynamic id;
  late String userShortName;
  late String userLongName;
  late String timeString;
  late String description;
  late String imageURL;
  late int numComments;
  late int numRetweets;
  late int numLikes;
  late int isLiked;
 late List<Comment> comments; 
  


  Tweet({
    this.id,
    required this.userShortName,
    required this.userLongName,
    required this.timeString,
    required this.description,
    required this.imageURL,
    required this.numComments,
    required this.numRetweets,
    required this.numLikes,
    required this.isLiked,
    required this.comments});

  Map<String, dynamic> toMap() 
  {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['userShortName'] = userShortName;
    map['userLongName'] = userLongName;
    map['timeString'] = timeString;
    map['description'] = description;
    map['imageURL'] = imageURL;
    map['numComments'] = numComments;
    map['numRetweets'] = numRetweets;
    map['numLikes'] = numLikes;
    map['isLiked'] = isLiked;
    map['comments'] = comments.map((comment)=>comment.toMap()).toList();
    return map;
  }

  Tweet.fromMap(Map<String, dynamic> map) 
  {
    id = map['id'];
    userShortName = map['userShortName'];
    userLongName= map['userLongName'];
    timeString= map['timeString'];
    description = map['description'];
    imageURL = map['imageURL'];
    numComments = map['numComments'] ?? 0;
    numRetweets = map['numRetweets'] ?? 0;
    numLikes = map['numLikes'] ?? 0;
    isLiked = map['isLiked'];
    comments = (map['comments'] as List<dynamic>?)
          ?.map((commentMap) => Comment.fromMap(commentMap))
          .toList() ?? [];
  }


}

class Comment {
  int id;
  int tweetId;
  String username;
  String text;
  String timestamp;

  Comment({
    required this.id,
    required this.tweetId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tweetId': tweetId,
      'username': username,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      tweetId: map['tweetId'],
      username: map['username'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}