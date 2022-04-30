import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final testSNP = StateNotifierProvider<TestSN,int>((ref) => TestSN());
class TestSN extends StateNotifier<int> {
  TestSN() : super(0);
}

class CwInitPage extends ConsumerWidget {
  const CwInitPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(testSNP);
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'あうあう',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ), 
    );
  }

  Widget result({required dynamic obj}){
    return Scaffold(
        body: Center(
          child: Text('Result'),
        )
    );
  }
  
  Widget loading(){
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      )
    );
  }

  Widget error(){
    return Scaffold(
        body: Center(
          child: Text('Error'),
        )
    );
  }
}


