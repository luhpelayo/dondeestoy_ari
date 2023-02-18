import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:geolocator/geolocator.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  
  runApp(const MyApp());
}

//la parte sensor
FlutterTts flutterTts = FlutterTts();


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
    
    _speak("Bienvenido a la aplicación");

     
    initializeTts();
    //aumente para q no tengala necesidad de iniciar buton
    initSpeechState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
     
    _flutterTts.stop();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        if (_isNear) {
          //_speak("Hola, ¿cómo estás?");
            
            hablar();
          
            
          
        }
       
      });
    });
  }

 



//de la assistente de voz


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
        print(isPlaying);
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
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APP DONDE ESTOY'),
          backgroundColor: Color.fromARGB(255, 24, 109, 213)
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
                      child: Text('Hablar'),
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
    print('entre pelayo');
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
       print('entre pelayo');
    });
  }
  


  comandos(String txt) async {
    switch (txt) {
      case 'hola ari ':
        temp = 'Hola Matias';
        _speak(temp);
        
	    break;
      case 'hola ari':
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
      case 'abrir':
        temp = 'Abriendo aplicacion Donde estoy';
        _speak(temp);
      
        
	    break;

      case 'abrir ':
        temp = 'Abriendo aplicacion Donde estoy';
        _speak(temp);
 
	    break; 

      case 'qué día es hoy ':
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
      print(formattedDate); // imprime algo como "14/02/2023 15:30"
        temp = formattedDate;
        _speak(temp);
 
	    break; 
      case 'qué día es hoy':
         final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
      print(formattedDate); // imprime algo como "14/02/2023 15:30"
        temp = formattedDate;
        _speak(temp);
 
	    break; 

  case 'mandar mi ubicación ':
        temp = 'Mandando la ubicación al responsable por whatsapp';
        _speak(temp);
     
         Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           final double latitude = position.latitude;
           final double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
        final url3 = "https://wa.me/59170976802?text=Hola,%20¿Podes%20venir%20por%20mi?%0A%0AEste%20es%20el%20enlace%20de%20Google%20Maps:%20https://www.google.com/maps?q=$latitude,$longitude";
         await launch(url3);
      break;

     case 'mandar mi ubicación':
        temp = 'Mandando la ubicación al responsable por whatsapp';
        _speak(temp);
       
         Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           final double latitude = position.latitude;
           final double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
       final url3 = "https://wa.me/59170976802?text=Hola,%20¿Podes%20venir%20por%20mi?%0A%0AEste%20es%20el%20enlace%20de%20Google%20Maps:%20https://www.google.com/maps?q=$latitude,$longitude";
         await launch(url3);
      break;

      case 'mandar ubicación ':
        temp = 'Mandando la ubicación al responsable por whatsapp';
        _speak(temp);
           final String numero ='59170976802';
         final String mensagem ='podes venir a recoger a Pelayo';
         Future<void> enviarMensagemWhatsApp(String numero, String mensagem) async {
    final url = 'https://wa.me/$numero?text=${Uri.encodeFull(mensagem)}';
  if (await canLaunch(url)) {
    await launch(url);
    print(url);
  } else {
    throw 'No fue posible abrir $url';
  }
}
        //enviarMensagemWhatsApp('59170976802', 'Olá, podes venir a recoger a Pelayo');
        //final url2 = "https://wa.me/59170976802?text=Hola,%20¿cómo%20estás?";
        //await launch(url2);


         Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           final double latitude = position.latitude;
           final double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
        final url3 = "https://wa.me/59170976802?text=Hola,%20¿Podes%20venir%20por%20mi?%0A%0AEste%20es%20el%20enlace%20de%20Google%20Maps:%20https://www.google.com/maps?q=$latitude,$longitude";
         await launch(url3);
      break;

     case 'mandar ubicación':
        temp = 'Mandando la ubicación al responsable por whatsapp';
        _speak(temp);
         final String numero ='59170976802';
         final String mensagem ='podes venir a recoger a Pelayo';
         Future<void> enviarMensagemWhatsApp(String numero, String mensagem) async {
         final url = 'https://wa.me/$numero?text=${Uri.encodeFull(mensagem)}';
          if (await canLaunch(url)) {
          await launch(url);
          print(url);
          } else {
          throw 'No fue posible abrir $url';
          }
          }
        //enviarMensagemWhatsApp('59170976802', 'Olá, podes venir a recoger a Pelayo');
        //final url3 = "https://wa.me/59170976802?text=Hola,%20¿cómo%20estás?";
        //await launch(url3);
         Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           final double latitude = position.latitude;
           final double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
       final url3 = "https://wa.me/59170976802?text=Hola,%20¿Podes%20venir%20por%20mi?%0A%0AEste%20es%20el%20enlace%20de%20Google%20Maps:%20https://www.google.com/maps?q=$latitude,$longitude";
         await launch(url3);
      break;

      case 'mi ubicación actual':
        
    
          /*Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           double latitude = position.latitude;
            double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
            
        //temp = 'En los módulos universitarios te encuentras en este momento';
        //_speak(temp);
      String apiKey = "AIzaSyA58OP0geQlmdzlSdFymUylTKUoDst6HRo";
      double lat = latitude;
      double lng = longitude;
      String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyA58OP0geQlmdzlSdFymUylTKUoDst6HRo";
      var response = await http.get(Uri.parse(url));
      var json = jsonDecode(response.body);
      String streetAddress = json["results"][0]["formatted_address"];
      print(streetAddress);
      print("ese es api2"); */
       temp = "segun las coordenadas";
      _speak(temp);
	    break;

      case 'mi ubicación actual ':
    
          /*Position position = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.high,
          );

           double latitude = position.latitude;
            double longitude = position.longitude;

           print('Latitude: $latitude, Longitude: $longitude');
            
        //temp = 'En los módulos universitarios te encuentras en este momento';
        //_speak(temp);
      String apiKey = "AIzaSyA58OP0geQlmdzlSdFymUylTKUoDst6HRo";
      double lat = latitude;
      double lng = longitude;
      String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyA58OP0geQlmdzlSdFymUylTKUoDst6HRo";
      var response = await http.get(Uri.parse(url));
      var json = jsonDecode(response.body);
      String streetAddress = json["results"][0]["formatted_address"];
      print(streetAddress);
      print("ese es api2"); */
       temp = "segun las coordenadas";
        _speak(temp);
	    break;


      case 'dónde estoy':
        
       
       temp = 'En los módulos universitarios te encuentras en este momento';
        _speak(temp);
	    break;
      case 'dónde estoy ':
      
         
       temp = 'En los módulos universitarios te encuentras en este momento';
        _speak(temp);
	    break;
      case 'dónde estoy?':
        temp = 'En los módulos universitarios te encuentras en este momento';
        _speak(temp);
        
	    break;
      case 'dónde estoy? ':
        temp = 'En los módulos universitarios te encuentras en este momento';
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






//la parte background
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  
  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      
    ),
  );

  service.startService();
}

 
// run app from xcode, then from xcode menu, select Simulate Background Fetch


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        // service.setForegroundNotificationInfo(
        //   title: "My App Service",
        //   content: "Updated at ${DateTime.now()}",
        // );
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

mixin DartPluginRegistrant {
  static void ensureInitialized() {}
}





class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late final Timer timer;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      logs = sp.getStringList('log') ?? [];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
        return Text(log);
      },
    );
  }
} 
*/