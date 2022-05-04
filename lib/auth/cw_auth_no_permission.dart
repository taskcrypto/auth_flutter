import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cw_auth_sign_in.dart';
import 'cw_init_page.dart';

final requestPermissionSP = StreamProvider.autoDispose((_) {
  final ref = FirebaseFirestore.instance.collection('requestPermissions');
  return ref.snapshots().map((snapshot) {
    final list = snapshot.docs
        .map((doc) => Animal(doc.id, doc.data()['name']))
        .toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  });
});

class CwAuthNoPermission extends ConsumerWidget {
  const CwAuthNoPermission({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthChange = ref.watch(firebaseUserSP);
    return userAuthChange.when(
        data: (user) => (user == null) ? SignInPage():CwInitPage(),
        error: (e,s) => errorView(),
        loading: () => loadingView()
    );
  }

  Widget requestPermissionView(BuildContext context, WidgetRef ref){
    return
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
