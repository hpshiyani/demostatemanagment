import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class viewdata extends StatefulWidget {
  const viewdata({Key? key}) : super(key: key);

  @override
  _viewdataState createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {

  List l=[];
  bool status = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlldata();

  }

   getAlldata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("RealtimeData");
    DatabaseEvent de = await ref.once();

    // de.snapshot.value;

    print("======${de.snapshot.value}");

    Map m = de.snapshot.value as Map;

    m.forEach((key, value) {

      l.add(value);
      setState(() {
        status = true;
      });
    });

    print("M===$l");
      // l = mm.map((e) =>RealTimeView.fromJson(e)).toList();
      // setState(() {
      //   status = true;
      // });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold( body:  status?ListView.builder(
      itemCount: l.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(onTap: () async {
              DatabaseReference ref =
              FirebaseDatabase.instance.ref("RealtimeData").child(l[index]['id']);
              String? id = ref.key;

              await ref.set({
                "name": "newname",
                "id": id,
                "email": "newemail",
                "image": "https://play-lh.googleusercontent.com/f2PVUHsy6mWms3KYZ5hAARkp4CsEAJkY0NWRdK7ttZdhGJjjZdn4WqBFyTJQmm2Jcnz8=s180-rw",
                "number": "899888987"
              });

              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return viewdata();
                },
              ));


            },child: Text("Update")), PopupMenuItem(onTap: () async {
              DatabaseReference ref =
              FirebaseDatabase.instance.ref("RealtimeData").child(l[index]['id']);
              String? id = ref.key;

              await ref.remove();

              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return viewdata();
                },
              ));
            },child: Text("Delete"))
          ],),
          leading: Image.network("${l[index]['image']}"),
          title: Text("${l[index]['name']}"),
        );
      },
    ):Center(child: CircularProgressIndicator()),
      // body: FutureBuilder(future: getAlldata(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasData) {
      //
      //         List<RealTimeView> l = snapshot.data as List<RealTimeView>;
      //         print("====${l[0].email}");
      //         return ListView.builder(
      //           itemCount: l.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               leading: Image.network("${l[index].image}"),
      //               title: Text("${l[index].name}"),
      //             );
      //           },
      //         );
      //       } else {
      //         return Text("No Data");
      //       }
      //     }
      //     return CircularProgressIndicator();
      //   },
      //
      // ),
    );
  }
}
//
// class RealTimeView {
//   String? image;
//   String? number;
//   String? name;
//   String? id;
//   String? email;
//
//   RealTimeView({this.image, this.number, this.name, this.id, this.email});
//
//   RealTimeView.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//     number = json['number'];
//     name = json['name'];
//     id = json['id'];
//     email = json['email'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['image'] = this.image;
//     data['number'] = this.number;
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['email'] = this.email;
//     return data;
//   }
// }
