import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBoardScreen extends StatelessWidget {
  final String boardName;

  MessageBoardScreen(this.boardName);

  final TextEditingController _messageController = TextEditingController();

  void _postMessage(BuildContext context) async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Fetch the username from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          // Check if the user document exists and contains the 'username' field
          if (userDoc.exists) {
            // Retrieve the username from the document or use 'Unknown' as default
            String username =
                (userDoc.data() as Map<String, dynamic>)['username'] ??
                    'Unknown';

            // Add the message to the message board's collection with the board name
            await FirebaseFirestore.instance.collection(boardName).add({
              'userId': user.uid,
              'username': username,
              'message': message,
              'timestamp': DateTime.now(),
            });

            // Show a snackbar indicating successful message posting
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Message posted')),
            );

            // Clear the message input field
            _messageController.clear();
          } else {
            // Handle the case where the user document doesn't exist
            print('User document does not exist');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Error posting message: User document not found')),
            );
          }
        }
      } catch (e) {
        print('Error posting message: $e');
        // Show an error snackbar if posting the message fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting message')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(boardName)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title:
                          Text(message['username'] + ': ' + message['message']),
                      subtitle:
                          Text('${message['timestamp'].toDate().toString()}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _postMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

