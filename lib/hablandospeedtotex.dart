import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/*
void main() => runApp(homePage()); 

class homePage extends StatefulWidget{

@override 
_homePageState createState() => _homePageState();
}
class _homePageState extends State<homePage> {
  bool isPlaying = false;
  late FlutterTts _flutterTts;
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000; 
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = 'es-ES';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  String temp = '';
  final SpeechToText speech = SpeechToText();


@override
  void initState() {
    super.initState();
    initializeTts();
    //aumente para q no tengala necesidad de iniciar buton
    initSpeechState();
  }

  
    @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }


  initializeTts() {
    _flutterTts = FlutterTts();

   setTtsLanguage();



    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
      isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occured:" + err);
        isPlaying = false;
      });
    });
  }
void setTtsLanguage() async {
     await _flutterTts.setLanguage("es-ES");
  }
void speechSettings1(){

  _flutterTts.setPitch(1.5);
  _flutterTts.setSpeechRate(.9);
}
void speechSettings2(){

  _flutterTts.setPitch(1);
  _flutterTts.setSpeechRate(0.5);
}

 Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if(result== 1)
      setState(() {
        isPlaying=true;
      });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) setState(() {
      isPlaying= false;
    });
  } 
 Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      
       var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lili assistent'),
          backgroundColor: Colors.redAccent
        ),
        body: Column(children: [
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                       FlatButton(
  child: Text('Initialize'),
  onPressed: null,
),
                  ],
                ),
             
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Start'),
                       onPressed: (){
                          hablar();

                       }),
                  ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[],
            )

 ],
            ),
          ),
          Expanded(
            flex:4,
            child: Column(
              children: <Widget>[
                Expanded(child: Stack(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).selectedRowColor,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: .26,
                                spreadRadius: level * 1.5,
                                color: Colors.black.withOpacity(.05))
                             
                            ],
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.mic),
                            onPressed: () => null,
                          ),
                        ),
                      ),
                      ),
                  ],
                ),
                ),
              ],
              ),
            ),
        ]),
     ),
      );

}

startListening() async {
    lastWords = '';
    lastError = '';
    await speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

hablar() async{
  await startListening();
}

resultListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('Result Listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords}';
      temp = lastWords.toLowerCase();
   
      print(temp);
      comandos(temp);
    });
  }

  comandos(String txt) {
    switch (txt) {
      case 'Hola lili ':
        temp = 'Hola Matias';
        _speak(temp);
        
	    break;
      case 'Hola ':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'hola ':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'hola':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'Hola':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'Hola Lili':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'Hola Lili ':
        temp = 'Hola Pelayo';
        _speak(temp);
        
	    break;
      case 'que dia es hoy':
         temp = 'Sabado';
        _speak(temp);

        break;
      default:
        print('Errror');

    }
  }

   void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
   
    setState(() {
      this.level = level;
    });
  }

    void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }
  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }
}
*/