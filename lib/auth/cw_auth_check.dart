import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cw_auth_sign_in.dart';
import 'cw_init_page.dart';

final firebaseUserSP = StreamProvider((_) => FirebaseAuth.instance.authStateChanges());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthChange = ref.watch(firebaseUserSP);
    return userAuthChange.when(
        data: (user) => (user == null) ? SignInPage():CwInitPage(),
        error: (e,s) => errorView(),
        loading: () => loadingView()
    );
  }

  Widget loadingView(){
    return Scaffold(
      body: Center(
        child: Text('LOADING'),
      ),
    );
  }

  Widget errorView(){
    return Scaffold(
      body: Center(
        child: Text('ERROR'),
      ),
    );
  }
}
