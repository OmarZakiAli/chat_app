import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import './models/my_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ChatModel> _list = List();
  final FirebaseDatabase firedb = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  ChatModel chatModel;

  @override
  void initState() {
    super.initState();
    databaseReference = firedb.reference().child("secret_chat");
    databaseReference.onChildAdded.listen(_childAdded);
    databaseReference.onChildChanged.listen(_childChanged);

    chatModel = ChatModel("", "");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "secret chat",
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: globalKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => chatModel.name = val,
                      ),
                    ),

                    ListTile(
                      leading: Icon(Icons.message),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => chatModel.message = val,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),

                    //Send or Post button
                    FlatButton(
                      child: Text("Send"),
                      color: Colors.redAccent,
                      onPressed: () {
                        _submetPost();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: Center(
                child: FirebaseAnimatedList(
                  query: databaseReference,
                  itemBuilder: _buildList,
                ),
              )),
        ],
      ),
    ));
  }

  void _submetPost() {
    final FormState form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();

      databaseReference.push().set(chatModel.toMap());
    }
  }

  _childAdded(Event event) {
    setState(() {
      _list.add(ChatModel.fromSnapshot(event.snapshot));
    });
  }

  _childChanged(Event event) {}

  Widget _buildList(BuildContext context, DataSnapshot snapshot,
      Animation<double> animation, int index) {
    return new Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
        ),
        title: Text(_list[_list.length - 1 - index].name),
        subtitle: Text(_list[_list.length - 1 - index].message),
      ),
    );
  }
}
