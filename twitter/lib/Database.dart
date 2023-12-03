import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Tweet.dart';

class DatabaseHelper
{
  DatabaseHelper._privateConstructor();  
    static final DatabaseHelper instance = DatabaseHelper._privateConstructor(); 

    static Database? _database; 

   

    Future<Database> get database async { 
      _database ??= await initializeDatabase();
      return _database!;
    }

    Future<Database> initializeDatabase() async {
   
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/tweet.db';

    var TweetsDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return TweetsDatabase;
  }
  void _createDb(Database db, int newVersion) async {
    await _createTweetsTable(db);
    await _createCommentsTable(db);
  }

Future<void> _createTweetsTable(Database db) async {
    await db.execute('''
      CREATE TABLE table_tweets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userShortName TEXT,
        userLongName TEXT,
        timeString TEXT,
        description TEXT,
        imageURL TEXT,
        numComments INTEGER,
        numRetweets INTEGER,
        numLikes INTEGER,
        isLiked INTEGER
      )
    ''');
  }

  Future<void> _createCommentsTable(Database db) async {
    await db.execute('''
      CREATE TABLE table_comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tweetId INTEGER,
        username TEXT,
        text TEXT,
        timestamp TEXT,
        FOREIGN KEY (tweetId) REFERENCES table_tweets(id)
      )
    ''');
  }
  Future<int> insertTweet(Tweet t) async {
 

    Database db = await instance.database;
   

    int result = await db.insert('table_tweets', t.toMap());

    return result;
  }

  Future<List<Tweet>> getAllTweets() async {
    List<Tweet> tweets = [];

   
    Database db = await instance.database;
    

    List<Map<String, dynamic>> listMap = await db.query('table_tweets');

    for (var TweetMap in listMap) {
      Tweet t = Tweet.fromMap(TweetMap);
      tweets.add(t);
    }

    await Future.delayed(const Duration(seconds: 2));
    return tweets;
  }

  Future<int> updateTweet(Tweet t) async { 
    Database db = await instance.database;
    
    int result = await db.update('table_tweets', t.toMap(), where: 'id=?', whereArgs: [t.id]);
    return result;
  }

  Future<int> deleteTweet(int id) async { 
    Database db = await instance.database;
    

    int result = await db.delete('table_tweets', where: 'id=?', whereArgs: [id]);
    return result;
  }


  Future<void> incrementCommentCount(int id) async {
    Database db = await instance.database;

    await db.rawUpdate(
      'UPDATE table_tweets SET numComments = numComments + 1 WHERE id = ?',
      [id],
    );
  }

  Future<List<Tweet>> getCommentsForTweet(int id) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> listMap = await db.query(
      'table_comments',
      where: 'tweetId = ?',
      whereArgs: [id],
    );

    List<Tweet> comments = [];

    for (var commentMap in listMap) {
      Tweet comment = Tweet.fromMap(commentMap);
      comments.add(comment);
    }

    return comments;
  }

  Future<int> insertComment(Tweet comment) async {
    Database db = await instance.database;
    int result = await db.insert('table_comments', comment.toMap());
    return result;
  }
}



