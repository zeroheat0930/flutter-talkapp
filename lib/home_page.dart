import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:talk/chat_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  TextEditingController _textEditingController = TextEditingController();

  List<String> _chats = [];
  final PreferredSizeWidget apppbar = (Platform.isIOS ? CupertinoNavigationBar() : AppBar(title: Text("Chat App"),)) as PreferredSizeWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: apppbar,
      body: Column(
        children: [
          Expanded(
              child: AnimatedList(
                  key: _animListKey,
                  reverse: true,
                  itemBuilder: _buildItem
              ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Platform.isIOS?CupertinoTextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    placeholder: "메세지 입력창",
                  ):TextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: "메세지 입력창"
                    ),
                  ),
                ),
                SizedBox(width: 8.0,),

                Platform.isIOS?CupertinoButton(
                    child: Text("send"), onPressed:
    (){
    _handleSubmitted(_textEditingController.text);
    },)
                    :ElevatedButton(
                    onPressed: (){
                      _handleSubmitted(_textEditingController.text);
                    },
                    child:Text("보내기"),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      primary: Colors.black,
                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(context, index, animation){
    return ChatMessage(_chats[index], animation: animation);
  }

  void _handleSubmitted(String text){
    Logger().d(text);
    _textEditingController.clear();
    _chats.insert(0, text);
    _animListKey.currentState!.insertItem(0);
  }
}
