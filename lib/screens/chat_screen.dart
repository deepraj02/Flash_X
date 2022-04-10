import 'package:flash_x/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_x/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
late String messageText;
final List<TheBubble> messageBubbles = [];
final messageTextController = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  // void getMessages () async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

/*   void getMessage() {
    _firestore.collection("messages").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  } */

  //@ Using Stream for Real-time Update

/*   void messagesStream() {
    _firestore.collection("messages").snapshots().listen((result) {
      result.docs.forEach((result) {
        print(result.data());
      });
    });
  }
 */
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/chbg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.call), onPressed: () {}),
            IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  messagesStream();
                  _auth.signOut();
                  //getMessage();
                  Navigator.popAndPushNamed(context, WelcomeScreen.id);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Stack(
          children: <Widget>[
            //StreamBuilder(builder: builder)
            MessageBuilder(),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        style:
                            TextStyle(color: Color.fromARGB(255, 48, 44, 44)),
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(137, 12, 3, 3)),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        List<TheBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.email;
          ;

          bool isMe = currentUser == messageSender;

          final messageBubble =
              TheBubble(text: messageText, sender: messageSender, isMe: isMe);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageBubbles,
        ));
      },
    );
  }
}

class TheBubble extends StatelessWidget {
  TheBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              color: isMe
                  ? Color.fromARGB(221, 18, 16, 16)
                  : Color.fromARGB(255, 25, 13, 95),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 6,
            color: isMe
                ? Color.fromARGB(255, 80, 213, 53)
                : Color.fromARGB(255, 59, 119, 223),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 23, 12, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
