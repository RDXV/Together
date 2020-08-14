// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:together/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

// We need authentication of email to chat with people
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Make sure that while using firebbase collection, the names need to match completely
  final _auth = FirebaseAuth.instance;
  final messageTextController =
      TextEditingController(); // for clearing the message after send buton pressed

  String messageText;

  // instance of firestore

  // this is instance of current user

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      // print(user);
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  //1
  // void messageStream() async {
  //   //snapshots notify of any new results
  //   // The snapshot here is firebase queery snapshot
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.documents) {
  //       print(message.data);
  //     }
  //   }
  // }

//2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // not this -> loggedInUser.delete();

                _auth.signOut();
                Navigator.pop(context);
                // getMessages();
                // messageStream();

                // after sign out pop to back screen
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // StreamBuilder for storing messages as Future<Stream>
            // The snapshot inside builder is not same as the firebase query snapshot as mentioned in loop much above
            // This is flutter async snapshot

            // builder requires logic for what stream builder should do
            // builder needs to rebuild all the children of the streamBuilder which is column of text widgets
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                        // Now we have messagetext  and know the details of logged in user
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      // Clears the textfield after send button pressed
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': FieldValue.serverTimestamp(), //added
                      });
                      // It expects  a map with string and a key where key is sender,text and their data is the string
                      // path refers to name of the collection of firestore
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(),
      //added .orderBy('time', descending: false) in between
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        // for making messages better
        // final Newmessages = snapshot.data.documents;
        List<MessageBubble> messageBubbleList = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentUser = loggedInUser.email;
          final messageTime = message.data['time'] as Timestamp; // added

          final messageBubble = MessageBubble(
            sender: messageSender,
            message: messageText,
            isMe: currentUser == messageSender,
            time: messageTime,
          );

          messageBubbleList.add(messageBubble);
        }
        // If above curly braces above //3 then only 1 message show
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbleList,
          ),
        );

        //3
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  final Timestamp time; //added

  MessageBubble(
      {this.message, this.sender, this.isMe, this.time}); //changed time to
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$sender ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}', //changed
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            // borderRadius: BorderRadius.circular(7.0),
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    topRight: Radius.circular(7.0),
                    bottomLeft: Radius.circular(7.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    topRight: Radius.circular(7.0),
                    bottomRight: Radius.circular(7.0),
                  ),
            // color: Colors.lightBlueAccent,
            color: isMe == true ? Colors.lightBlueAccent : Colors.yellow[800],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 1 - void getMessages() async {
//   final messages = await _firestore.collection('messages').getDocuments();
//   // message.documents() have all the messages
//   for (var message in messages.documents) {
//     print(message.data);
//   }
// Current approach of getting the old messages each time is not good
// It would be better to find a way to push the messages to the app rather than pulling each time the old messages
// from the database
// }

// Note that the getDocuments() returns a list  of

// We need to use stream of messages

// 2 - Because of first for loop you are subscribed to changes in the messages collection through snapshots which notifies
// changes and then the message variable goes through snpashot.documents and print the changes in the list rather than
// everything being printed out

// It is like a list of futures and by associating a value, we can listen to all changes that happen in stream of messages

// Best to initialise the above at start in initstate
// We will use the stream of messages by async and await and then storing them inside snapshots in for loop through
// snapshots

// 3 - IMPORTANT
// snapshot -> Asyncsnapshot contains querySnapshot from firebase
// data -> QuerySnapshot. We access  QuerySnapshot through the data property
// document -> ListDocument which is QuerySnapshot object to use QuerySnapshot property like the
// documents property which gives us a list of document snapshots
// Summary- AsyncSnapshot from streamBuilder contains querySnapshot from firebase. The querySnapshot in turn
// contains a list of Document Snapshots

// * Also note that message.data[] and snapshot.data.documents are very different
