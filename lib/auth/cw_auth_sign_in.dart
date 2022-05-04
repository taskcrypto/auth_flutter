import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:ritest/auth/cw_signin_apple.dart';

import 'cw_signin_twitter.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buttonSigninWithGoogle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buttonSigninWithTwitter(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buttonSigninWithApple(),
          ),
          Spacer(),
        ],
      )
    );
  }

  Widget buttonSigninWithGoogle(){
    return Center(
      child: Container(
        //clipBehavior: Clip.antiAlias,
        height: 40,
        width: 240,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(
                  'assets/images/google_logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.grey,fontSize: 18),
                ),
              ),
            ],
          ),
          onPressed: () async {
            await signInWithGoogle();
            var fcmToken = await FirebaseMessaging.instance.getToken()
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .set(<String, dynamic>{
                'fcmToken': value,
                'userProfile':{
                  'mail':FirebaseAuth.instance.currentUser?.email,
                  'displayName':FirebaseAuth.instance.currentUser?.displayName,
                  'photoURL':FirebaseAuth.instance.currentUser?.photoURL,
                  'uid':FirebaseAuth.instance.currentUser?.uid,
                  'tenantId':FirebaseAuth.instance.currentUser?.tenantId,
                }
              }, SetOptions(merge: true));
            })
                .onError((error, stackTrace){
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .set(<String, dynamic>{
                'userProfile':{
                  'mail':FirebaseAuth.instance.currentUser?.email,
                  'displayName':FirebaseAuth.instance.currentUser?.displayName,
                  'photoURL':FirebaseAuth.instance.currentUser?.photoURL,
                  'uid':FirebaseAuth.instance.currentUser?.uid,
                  'tenantId':FirebaseAuth.instance.currentUser?.tenantId,
                }
              }, SetOptions(merge: true));
            });

          },
        ),
      ),
    );
  }

  Widget buttonSigninWithTwitter(){
    return Center(
      child: Container(
        //clipBehavior: Clip.antiAlias,
        height: 40,
        width: 240,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Icon(FontAwesome.twitter,color: Colors.blue,)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sign in with Twitter',
                  style: TextStyle(color: Colors.grey,fontSize: 18),
                ),
              ),
            ],
          ),
          onPressed: () async {
            if (kIsWeb){
              final c =  await signInWithTwitterForWeb();
              if (FirebaseAuth.instance.currentUser?.uid != null){
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set(<String, dynamic>{
                  'userProfile':{
                    'mail':FirebaseAuth.instance.currentUser?.email,
                    'displayName':FirebaseAuth.instance.currentUser?.displayName,
                    'photoURL':FirebaseAuth.instance.currentUser?.photoURL,
                    'uid':FirebaseAuth.instance.currentUser?.uid,
                    'tenantId':FirebaseAuth.instance.currentUser?.tenantId,
                  }
                }, SetOptions(merge: true));
              }

            }else{
              final c =  await signInWithTwitterForNative();
            }
          },
        ),
      ),
    );
  }

  Widget buttonSigninWithApple(){
    return Center(
      child: Container(
        //clipBehavior: Clip.antiAlias,
        height: 40,
        width: 240,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Icon(FontAwesome.apple,color: Colors.black87,)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sign in with Apple',
                  style: TextStyle(color: Colors.grey,fontSize: 18),
                ),
              ),
            ],
          ),
          onPressed: () async {
            if (kIsWeb){
              final c =  await signInWithAppleForWeb();
            }else{
              final c =  await signInWithAppleForWeb();
            }
          },
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb){
      return await signInWithGoogleByWeb();
    }else{
      return await signInWithGoogleByNative();
    }
  }

  Future<UserCredential> signInWithGoogleByNative() async {
    debugPrint('[SignInPage]signInWithGoogleByNative');

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogleByWeb() async {
    debugPrint('[SignInPage]signInWithGoogleByWeb');
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }


  Future<void> signInWithGoogleSignOut() async {
    if (!kIsWeb){
      await GoogleSignIn().signOut();
    }
    await FirebaseAuth.instance.signOut();
  }


  void _showButtonPressDialog(BuildContext context, String provider) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$provider Button Pressed!'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 400),
    ));
  }
}

