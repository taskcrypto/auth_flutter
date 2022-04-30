import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cw_auth_sign_in.dart';
import 'cw_init_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

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
