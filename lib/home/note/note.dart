import 'package:flutter/material.dart';

class FriNote {
  int fnid;
  Color color;
  String title;
  DateTime date;

  FriNote({this.fnid, this.color, @required this.title, @required this.date});
}

class NoteDetail extends StatefulWidget {
  const NoteDetail({Key key, @required this.note}) : super(key: key);
  final FriNote note;

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: "frino_${widget.note.fnid}",
          // flightShuttleBuilder: (
          //   BuildContext flightContext,
          //   Animation<double> animation,
          //   HeroFlightDirection flightDirection,
          //   BuildContext fromHeroContext,
          //   BuildContext toHeroContext,
          // ) {
          //   return SingleChildScrollView(
          //     child: fromHeroContext.widget,
          //   );
          // },
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 500,
              width: 350,
              color: widget.note.color,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.note.title,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Center(
                      child: Text(
                        widget.note.date.toString(),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      height: 35,
                      alignment: Alignment.centerRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FlutterLogo(
                              size: 24,
                            ),
                          ),
                          Text("Frino user"),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            size: 35.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: 35.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
