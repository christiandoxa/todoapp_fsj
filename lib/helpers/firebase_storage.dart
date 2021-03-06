import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFile(File file) async {
  if (file == null) return null;
  User user = FirebaseAuth.instance.currentUser;
  UploadTask uploadTask;
  Reference ref = FirebaseStorage.instance
      .ref()
      .child(user.uid.toString())
      .child('taskImages')
      .child(Timestamp.now().nanoseconds.toString());
  uploadTask = ref.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask;
  return await taskSnapshot.ref.getDownloadURL();
}

Reference getRefFromUrl(String url) {
  if (url == null || url.isEmpty) return null;
  return FirebaseStorage.instance.refFromURL(url);
}
