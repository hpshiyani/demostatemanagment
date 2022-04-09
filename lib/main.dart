import 'package:demostatemanagment/demodrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'notifiredatabse.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MaterialApp(
    home: demodrop(),
  ));
}

class demoManage extends StatefulWidget {
  const demoManage({Key? key}) : super(key: key);

  @override
  _demoManageState createState() => _demoManageState();
}

class _demoManageState extends State<demoManage> {
  String verid = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(fillColor: Colors.black),
                controller: gmail,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: phone,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: otp,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: password,
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: googlelogin,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: gmail.text, password: password.text);
                    print("Register====$userCredential");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print("EE ==$e");
                  }
                },
                child: Text("Submit")),
            ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: gmail.text, password: password.text);
                    print("Login====$userCredential");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                child: Text("Login")),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+91${phone.text}",
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      setState(() {
                        verid = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                child: Text("phoneSubmit")),
            ElevatedButton(
                onPressed: () async {
                  String smsCode = otp.text;
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verid, smsCode: smsCode);

                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential);
                },
                child: Text("sent otp")),
            RaisedButton.icon(
                onPressed: () {
                  signInWithGoogle().then((value) {
                    print("====$value");
                  });
                },
                icon: Icon(Icons.email),
                label: Text("LOgin"))
          ],
        ),
      ),
    );
  }

  TextEditingController gmail = TextEditingController();
  TextEditingController googlelogin = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
