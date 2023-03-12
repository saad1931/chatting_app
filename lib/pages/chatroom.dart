import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child:Container(), 
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5
              ),
              child: Row(
                children: [
                  const Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Message"
                      ),
                    )
                    ),
                  IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.send)),
                    
                      
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}