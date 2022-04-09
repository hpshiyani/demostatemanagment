import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class demonoti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => demo(),
          child: Consumer<demo>(
            builder: (context, value, child) {
              return Column(
                children: [
                  Text("${value.cnt}"),
                  ElevatedButton(
                      onPressed: () {
                        value.increment();
                      },
                      child: Text("Increment"))
                ],
              );
            },
          )),
    );
  }
}

class demo extends ChangeNotifier {
  int cnt = 0;

  increment()
  {
    cnt++;
    notifyListeners();
  }
}
