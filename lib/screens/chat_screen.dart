import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore =FirebaseFirestore.instance;
  late User signedInUser;
class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
   String? messegeText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
   void messageStreams() async{
     await for( var snapshot in _firestore.collection('masseges').snapshots()){
       for ( var message in snapshot.docs){
          print(message.data());
       }
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              messageStreams();
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            MasseageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messegeText= value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       messageTextController.clear();
                      _firestore.collection('masseges').add({
                        'text':messegeText,
                         'sender':signedInUser.email,
                        'time':FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 class MessageLine extends StatelessWidget{
  const MessageLine({Key? key, required this.sender, required this.text, required this.isMe, }) : super(key: key);
  final String? sender;
  final String ?text;
  final  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
      children: [
        Text('$sender', style: TextStyle( fontSize: 12,color: Colors.yellow[900]),),
        Material(
          elevation: 5,
          borderRadius: isMe? BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft:Radius.circular(30),
            bottomRight: Radius.circular(30),
          ):BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft:Radius.circular(30),
            bottomRight: Radius.circular(30),),
          color: isMe?Colors.blue[800]:Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child:Text(
              '$text',
              style: TextStyle( fontSize: 15, color: isMe? Colors.white: Colors.black45),
            ),

          ),

        ),

      ],
    ));
  }

 }
 class MasseageStreamBuilder extends StatelessWidget{
  const MasseageStreamBuilder({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
        stream: _firestore.collection('masseges').snapshots(),
        builder: (context,snapshot){
          List<MessageLine> messageWidgets =[];

          if( !snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor:Colors.blue,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          for( var message in messages ){
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser =signedInUser.email;

               if( currentUser== messageSender) {

               }

            final messageWidget = MessageLine(sender: messageSender,text: messageText,
              isMe: currentUser== messageSender,);
            messageWidgets.add(messageWidget);
          }




          return Expanded(
            child:ListView(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageWidgets,) ,
          );}
    );
  }

 }