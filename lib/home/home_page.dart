import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/components/platform_alert_dialog.dart';
import 'package:frino/home/group/grouppage.dart';
import 'package:frino/home/note/noteform.dart';
import 'package:frino/palette.dart';
import 'package:frino/services/databaseservice.dart';
import 'package:provider/provider.dart';

import 'note/note.dart';

class HomePage extends StatefulWidget {
  FrinoUser user;
  HomePage({this.user});
  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      print("Signing out...");
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _confirmSignOut(BuildContext context) async {
    bool didsignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure you want to logout?",
      defaultActionText: "OK",
      cancelActionText: "Cancel",
    ).show(context);
    if (didsignOut) {
      widget._signOut(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: StreamBuilder(
        stream: DatabaseService(uid: widget.user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            widget.user = snapshot.data;
            // print(widget.user.name);
            final auth = Provider.of<AuthBase>(context, listen: false);
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                    accountName: Text(widget.user.name ?? ""),
                    accountEmail: Text(widget.user.email ?? ""),
                    currentAccountPicture: CircleAvatar(
                      child: FlutterLogo(
                        size: 42,
                      ),
                    )),
                // SizedBox(height: 400),
                ListTile(
                    leading: Icon(Icons.group),
                    title: Text("Groups"),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => GroupPage()));
                    }),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () => _confirmSignOut(context),
                )
              ],
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
        child: _buildNotes(context),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          // await DatabaseService(uid: widget.user.uid)
          //     .addFrino("Pick up Josh from school at 3 p.m");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteForm()));
        },
      ),
    );
  }

  Widget _buildNote(BuildContext context, FriNote frino) {
    final color = fnColors[Random().nextInt(fnColors.length)];
    final degrees = [-15, 0, 15];
    final degree = degrees[Random().nextInt(degrees.length)];
    frino.color = color;
    return Hero(
      tag: "frino_${frino.fnid}",
      child: Material(
        type: MaterialType.transparency,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(degree / 360),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 1500),
                // fullscreenDialog: true,
                pageBuilder: (_, __, ___) => NoteDetail(
                  note: frino,
                ),
              ));
            },
            splashColor: color,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 100,
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    frino.title,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    final frinos = Provider.of<List<FriNote>>(context);
    if (frinos == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(primaryColor),
        ),
      );
    }
    var index = 0, left = frinos.length;
    List<Widget> notes = [];

    for (var i = 0; i < frinos.length / 3; i++) {
      List<Widget> rows = [];
      var j_iter;
      if (left > 3) {
        j_iter = 3;
      } else {
        j_iter = left;
      }
      for (var j = 0; j < j_iter; j++) {
        var fnid = 2 * i + (i + j + 1);
        var frino = FriNote(
            title: frinos[index].title, date: frinos[index].date, fnid: fnid);
        rows.add(_buildNote(context, frino));
        left--;
        index++;
      }
      notes.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows,
      ));
      notes.add(SizedBox(
        height: 36,
      ));
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}
