import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frino/palette.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/services/databaseservice.dart';
import 'package:provider/provider.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({Key key}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  GlobalKey _groupKey = GlobalKey();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  ScrollController scrollcontroller = ScrollController();
  bool isSearching = false;
  List<String> userids = [];
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic> s_user;
  String s_userid;
  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthBase>(context, listen: false)
        .currentUser()
        .then((value) => user = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            !isSearching
                ? Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Group Name",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: namecontroller,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: -2, bottom: -2, left: 8),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: primaryColor),
                                // ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: desccontroller,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: -2, bottom: -2, left: 8),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: primaryColor),
                                // ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            keyboardType: TextInputType.name,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 16,
            ),
            Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      onTap: () {
                        // scrollcontroller.animateTo(8800,
                        //     duration: Duration(milliseconds: 300),
                        //     curve: Curves.ease);
                        setState(() {
                          isSearching = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          isSearching = false;
                        });
                        FocusScope.of(context).unfocus();
                        setState(() {
                          s_user = null;
                          s_userid = null;
                        });
                      },
                      onChanged: (text) async {
                        final userCollection =
                            FirebaseFirestore.instance.collection('users');
                        try {
                          await userCollection
                              .where("email", isEqualTo: text)
                              .get()
                              .then((value) {
                            setState(() {
                              s_user = value.docs[0].data();
                              s_userid = value.docs[0].id;
                            });
                          });
                        } catch (e) {
                          print(e);
                        } finally {
                          print(s_user);
                        }
                      },
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search People",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    s_user != null ? _listAccount(s_user) : Container(),
                  ],
                ),
              ),
            ),
            Spacer(),
            listPeople(),
            SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () async {
                var user = await Provider.of<AuthBase>(context, listen: false)
                    .currentUser();
                await DatabaseService(uid: user.uid)
                    .addGroup(namecontroller.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Group created"),
                  backgroundColor: primaryColor,
                ));
                Navigator.of(context).pop();
              },
              child: Text(
                "Create",
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        key: _groupKey,
      ),
    );
  }

  Widget _listAccount(Map<String, dynamic> user) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 0.5,
          )),
      child: Row(
        children: [
          Spacer(
            flex: 1,
          ),
          Icon(Icons.person),
          Spacer(
            flex: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(user["name"]), Text(user["email"])],
          ),
          Spacer(
            flex: 8,
          ),
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  users.add(s_user);
                  userids.add(s_userid);
                  s_user = null;
                  s_userid = null;
                });
              })
        ],
      ),
    );
  }

  Widget listPeople() {
    List<Widget> people = [];
    print(userids);
    for (var u in users) {
      people.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(u["name"]),
                  IconButton(
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: primaryColor,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: people,
      ),
    );
  }
}
