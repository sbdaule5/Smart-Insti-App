import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user_data.dart';
import 'achievement.dart';
import 'post.dart';
import 'por.dart';
import 'skill.dart';

class UserDataModel{
  static var profile = UserData(
    username: "",
    userID: "",
    description: [],
    profilePhotoURL: "",
    posts: <Post>[],
    achievements: <Achievement>[],
    skills: <Skill>[],
    pors: <Por>[],
    following : <String>[],
  );

  UserDataModel();
  static Future<UserData> fetch(String ldapId) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    late UserData myProfile;
    final docSnap = await db.collection('users')
        .doc(ldapId)
        .withConverter(
          fromFirestore: UserData.fromFirestore, 
          toFirestore: (UserData data, _) => data.toFirestore()
        ).get();
    myProfile = (docSnap.data() != null) ? docSnap.data()! : profile;
    return myProfile;
  }
  
  static Future<void> updateProfile(String ldapId, UserData profile) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    final docRef = db.collection('users')
      .withConverter(
          fromFirestore: UserData.fromFirestore, 
          toFirestore: (UserData data, _) => data.toFirestore()
        )
        .doc(ldapId);
    await docRef.set(profile);
  }

  static Future<void> follow(String myLdap, String followLdap) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    await db.collection('users')
        .doc(myLdap)
        .update({"following": FieldValue.arrayUnion([followLdap])});
  }

  static Future<void> unfollow(String myLdap, String followLdap) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    await db.collection('users')
        .doc(myLdap)
        .update({"following": FieldValue.arrayRemove([followLdap])});
  }
}