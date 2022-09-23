import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:file_picker/file_picker.dart';
import 'package:e_voting/utils/constants.dart';
import 'package:e_voting/widgets/snackbar.dart';
import 'package:e_voting/models/user_data.dart';
import 'package:e_voting/widgets/input_field.dart';
import 'package:e_voting/screens/login_screen.dart';
import 'package:e_voting/services/firestore_service.dart';
import 'package:e_voting/screens/edit_profile_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Constants.colors,
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () async => {
                  await FirebaseAuth.instance.signOut(),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false),
                  ScaffoldMessenger.of(context).showSnackBar(
                    showsnackbar(
                      Colors.black,
                      "Sign out Successful",
                      context,
                    ),
                  )
                },
                icon: const Icon(
                  Icons.logout_outlined,
                ),
              ),
              title: const Text(
                'Profile',
              ),
              centerTitle: true,
              actions: <Widget>[
                MaterialButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                  shape: const CircleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  child: const Text(
                    "Edit",
                  ),
                ),
              ],
            )
          : null,
      body: StreamBuilder<List<UserData>>(
        stream: FirestoreServices.readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return ProfileStream(users);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text("Working to get data");
        },
      ),
    );
  }
}

class ProfileStream extends StatefulWidget {
  const ProfileStream(
    this.users, {
    Key? key,
  }) : super(key: key);
  final List<UserData> users;

  @override
  State<ProfileStream> createState() => ProfileStreamState();
}

class ProfileStreamState extends State<ProfileStream> {
  late final idURL = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email!)
      .doc(widget.users[0].id)
      .toString();
  PlatformFile? pickedFile;
  UploadTask? upload;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 70,
                    width: 70,
                    foregroundDecoration: (widget.users[0].url != 'null')
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.users[0].url),
                              fit: BoxFit.fill,
                              scale: 0.5,
                            ),
                          )
                        : null,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.greyColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      icon: (widget.users[0].url == 'null')
                          ? const Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Constants.primarycolor,
                            )
                          : Image.asset(widget.users[0].url),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.users[0].fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff027314),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.users[0].email,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.greyColor,
                    ),
                  ),
                ),
              ),
              InputField(
                labeltext: 'Full Name',
                hintText: widget.users[0].fullName,
                readOnly: true,
              ),
              InputField(
                labeltext: 'Email',
                hintText: widget.users[0].email,
                readOnly: true,
              ),
              InputField(
                labeltext: 'CNIC',
                hintText: widget.users[0].cnic,
                readOnly: true,
              ),
              InputField(
                labeltext: 'Date of Expiry',
                hintText: widget.users[0].doe,
                readOnly: true,
              ),
              InputField(
                labeltext: 'Phone Number',
                hintText: widget.users[0].number,
                readOnly: true,
              ),
              InputField(
                labeltext: "Mother's Name",
                hintText: widget.users[0].mName,
                readOnly: true,
              ),
              InputField(
                labeltext: 'Permanent Address',
                hintText: widget.users[0].perAddress,
                readOnly: true,
              ),
              InputField(
                labeltext: 'Current Address',
                hintText: widget.users[0].currAddress,
                readOnly: true,
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
