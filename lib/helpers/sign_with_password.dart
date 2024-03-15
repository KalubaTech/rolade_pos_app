import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rolade_pos/models/user_model.dart';
import 'package:rolade_pos/views/pages_anchor.dart';

class SignInPassword {
  UserModel userModel = UserModel(uid: '', email: '', displayName: '', photo: '', datetime: '',password: '');
  FirebaseFirestore fs = FirebaseFirestore.instance;
  UserModel signIn(String email,String password){

     fs.collection('users').where('email', isEqualTo: email).where('password', isEqualTo: password).get()
       .then((value){
            userModel = UserModel(
                uid: value.docs.first.id,
                email: value.docs.first.data()['email'],
                displayName: value.docs.first.data()['displayName'],
                photo: value.docs.first.data()['photo'],
                datetime: value.docs.first.data()['datetime'],
                password: value.docs.first.data()['password']
            );

            GetStorage().write('user', userModel.email);
       } );

     return userModel;

  }

}