import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  late DialogFlow dialogflow;

  @override
  void initState() {
    super.initState();
    initDialogflow();
  }
Future<void> initDialogflow() async {
    final authGoogle =
        await AuthGoogle(fileJson: 'assets/pelayo-telp-9fd3686424f3.json')
            .build();
    dialogflow = DialogFlow(authGoogle: authGoogle, language: Language.spanish);
  }


   
   Future<void> queryDialogflow(String text) async {
    final response = await dialogflow.detectIntent(text);
    final fulfillmentText = response.queryResult?.fulfillmentText;

    // Reproducir la respuesta
    print(fulfillmentText);
    _speak(fulfillmentText!);
    setState(() {
      _controller.text = fulfillmentText ?? '';
    });
  }


    Future<void> _speak(String? text) async {
    if (text == null) return;
    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak(text);
  }

   void _listen() async {
    if (!_speech.isAvailable) {
      return;
    }

    _speech.listen(
        onResult: (result) {
          final text = result.recognizedWords;
          setState(() {
            _controller.text = text;
          });
          queryDialogflow(text);
        },
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        cancelOnError: true,
        partialResults: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialogflow Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dialogflow Flutter Demo'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Escriba su mensaje...',
                ),
              ),
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text('Enviar'),
              onPressed: () {
                final text = _controller.text;
                queryDialogflow(text);
              },
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text('Hablar'),
              onPressed: () {
                _listen();
              },
            ),
          ],
        ),
      ),
    );
  }
  
 RaisedButton({
  Text? child, 
  void Function()? onPressed,
}) {}

}