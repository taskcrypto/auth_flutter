import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_login/twitter_login.dart';

Future<UserCredential> signInWithTwitterForNative() async {
  // Create a TwitterLogin instance
  final twitterLogin = new TwitterLogin(
      apiKey: '<your consumer key>',
      apiSecretKey:' <your consumer secret>',
      redirectURI: '<your_scheme>://'
  );
  // Trigger the sign-in flow
  final authResult = await twitterLogin.login();
  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: authResult.authToken!,
    secret: authResult.authTokenSecret!,
  );
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
}

Future<UserCredential> signInWithTwitterForWeb() async {
  // Create a new provider
  TwitterAuthProvider twitterProvider = TwitterAuthProvider();
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(twitterProvider);
  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(twitterProvider);
}