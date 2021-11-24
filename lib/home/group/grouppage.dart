import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/home/group/groupform.dart';
import 'package:frino/palette.dart';
import 'package:frino/services/databaseservice.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: Provider.of<AuthBase>(context, listen: false).currentUser(),
          builder: (context, snapshot) {
            var user;
            if (snapshot.hasData) {
              user = snapshot.data;

              return StreamBuilder(
                  stream: DatabaseService(uid: user.uid).groups,
                  builder: (context, snapshot) {
                    var groups;
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData == true) {
                        groups = snapshot.data;
                        print("DATA");
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: _listGroups(groups),
                      ),
                    );
                  });
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GroupForm()));
          }),
    );
  }

  List<Widget> _listGroups(List<String> groups) {
    List<Widget> col_widget = [
      Center(child: Text("Groups")),
    ];
    try {
      for (var g in groups) {
        col_widget.add(Text(g));
      }
    } catch (e) {}
    return col_widget;
  }
}
