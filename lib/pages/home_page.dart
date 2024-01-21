import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageMemory;
  bool showSignature = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/signature')
                    as Uint8List?;

                if (result != null) {
                  setState(() {
                    _imageMemory = result;
                    showSignature = _imageMemory != null;
                  });
                }

                setState(() {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                });
              },
              child: const Text('Assinatura'),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          SizedBox(
            height: 100,
            child: Visibility(
              visible: showSignature,
              child: showSignature
                  ? InteractiveViewer(child: Image.memory(_imageMemory!))
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
