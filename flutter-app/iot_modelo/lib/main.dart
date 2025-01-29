import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'IoT - Aprendizado de Máquina'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String? result;
  bool sendCapture = false;

  @override
  void initState() {
    super.initState();
    monitorResult();
  }

  void monitorResult() {
    databaseRef.child('result').onValue.listen((event) {
      final data = event.snapshot.value;
      if (mounted) {
        setState(() {
          result = data?.toString();
        });
      }
    }, onError: (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao monitorar o resultado: $error')),
        );
      }
    });
  }

  Future<void> sendCaptureToFirebase() async {
    try {
      await databaseRef.child('sendCapture').set(true);
      setState(() {
        sendCapture = true;
        result = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Começando a captura!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar capture: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF071635),
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/IoT-coverage-2.jpg',
            width: 200,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          if (result == "null" || result == null)
            if (sendCapture)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Aguardando resultado...',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Pressione o botão para capturar a imagem',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$result',
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: !sendCapture
            ? SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: sendCaptureToFirebase,
                  child: const Text(
                    'Capturar Imagem',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              )
            : SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () async {
                    await databaseRef.child('sendCapture').set(false);
                    await databaseRef.child('result').set("null");
                    setState(() {
                      sendCapture = false;
                      result = null;
                    });
                  },
                  child: const Text(
                    'Resetar',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }
}
