
import 'package:firebase_database/firebase_database.dart';

class ChatModel{

String _key;
String name="anonymous";
String message;

ChatModel(this.name,this.message);

ChatModel.fromSnapshot(DataSnapshot snap){

_key=snap.key;
name=snap.value["name"];
message=snap.value["message"];

}

toMap(){

return  {
"name":name,
"message":message
};

}


}