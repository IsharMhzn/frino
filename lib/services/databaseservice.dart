import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/home/note/note.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final userCollection = FirebaseFirestore.instance.collection('users');
  final groupCollection = FirebaseFirestore.instance.collection('groups');

  Future addGroup(String name) async {
    var gid;
    await groupCollection.add({"name": name}).then((value) => (gid = value.id));

    await userCollection
        .doc(this.uid)
        .collection('groups')
        .doc()
        .set({"id": gid});

    await groupCollection.doc(gid).collection('users').doc(this.uid).set({});
  }

  List<String> _groupFromSnapshot(QuerySnapshot snapshot) {
    var id_list = snapshot.docs.map<String>((doc) {
      return doc.get("id");
    }).toList();
    // print(id_list);
    return id_list;
  }

  Stream<List<String>> get groups {
    var snapshots =
        userCollection.doc(this.uid).collection('groups').snapshots();
    var a = snapshots.map(_groupFromSnapshot);
    return a;
  }

  Future addUser(String name, String email) async {
    return await userCollection.doc(this.uid).set({
      "name": name,
      "email": email,
      "date_created": DateTime.now(),
    });
  }

  FrinoUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return FrinoUser(
        uid: this.uid,
        name: snapshot.get("name") ?? "",
        email: snapshot.get("email") ?? "");
  }

  Stream<FrinoUser> get userData {
    return userCollection.doc(this.uid).snapshots().map(_userDataFromSnapshot);
  }

  Future addFrino(String title) async {
    return await userCollection
        .doc(this.uid)
        .collection('frinotes')
        .doc()
        .set({"title": title, "date": DateTime.now()});
  }

  List<FriNote> _frinoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            FriNote(title: doc.get('title'), date: doc.get('date').toDate()))
        .toList();
  }

  Stream<List<FriNote>> get frinos {
    var snapshots =
        userCollection.doc(this.uid).collection('frinotes').snapshots();
    return snapshots.map(_frinoListFromSnapshot);
  }
}
