import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/palette.dart';
import 'package:frino/services/databaseservice.dart';
import 'package:provider/provider.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key key}) : super(key: key);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  GlobalKey _notekey;
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 300,
          color: Colors.red[200],
          child: Form(
            key: _notekey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Note",
                  style: TextStyle(color: Colors.black, fontSize: 32),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextFormField(
                    controller: noteController,
                    maxLines: 2,
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primaryColor),
                  child: Text("Send"),
                  onPressed: () async {
                    var user =
                        await Provider.of<AuthBase>(context, listen: false)
                            .currentUser();
                    await DatabaseService(uid: user.uid)
                        .addFrino(noteController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
