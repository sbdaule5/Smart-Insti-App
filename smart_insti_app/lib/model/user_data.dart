import 'package:cloud_firestore/cloud_firestore.dart';

import 'achievement.dart';
import 'skill.dart';
import 'por.dart';

class UserData{
  String username;
  String userID;
  List<String> description;
  String profilePhotoURL;
  List<Achievement> achievements;
  List<Skill> skills;
  List<Por> pors;
  final List<String> following;
  UserData({
    required this.userID, 
    required this.username,
    required this.description,
    this.profilePhotoURL = "",
    required this.achievements,
    required this.skills,
    required this.pors,
    required this.following
  });


  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();

    return UserData(
      username: data?['name'],
      userID: snapshot.id,
      description: data?['description'].cast<String>(),
      profilePhotoURL: (data?['profilePhoto'] != null) ? 
        (data?['profilePhoto']) 
        : '',
      achievements: 
        data?['achievements'] is Iterable ?
          List.from(data?['achievements']).map((hashMap)=> Achievement.fromJson(hashMap)).toList()
          : <Achievement>[],
      skills:
        data?['skills'] is Iterable ?
          List.from(data?['skills']).map((hashMap)=> Skill.fromJson(hashMap)).toList()
          : <Skill>[],
      pors:
        data?['pors'] is Iterable ?
          List.from(data?['pors']).map((hashMap)=> Por.fromJson(hashMap)).toList()
          : <Por>[],
      following:
        data?['following'] is Iterable ?
          List.from(data?['following'])
          : <String>[],
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'name': username,
      'description': description,
      'achievements': achievements.map((achievement) => achievement.toJson()).toList(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'pors': pors.map((por)=>por.toJson()).toList(),
      'following': following
    };
  }
}
