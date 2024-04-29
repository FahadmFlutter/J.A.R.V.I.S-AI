import 'package:avatar_glow/avatar_glow.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    _initSpeech();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  void _initSpeech() async {
    _isListening = await _speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: screenSize.width,
              height: screenSize.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(1.00, -1.00),
                  end: const Alignment(1, 1),
                  colors: [
                    Colors.white,
                    Colors.deepPurple.shade300,
                    Colors.deepPurple.shade900
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Lottie.asset(
                    'assets/Animation - 1713548571117.json',
                    height: 300,
                  )),
                  SizedBox(
                    height: 150,
                  ),
                  Center(
                      child: Text(
                    'J.A.R.V.I.S.',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 40),
                  )),
                  Center(
                      child: Text(
                    'Your personal AI asistant.',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontSize: 14),
                  )),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            enabled: false,
                            border: InputBorder.none,
                            hintText: 'Tap 🎙️ and say "HELLO"',
                            hintStyle: TextStyle(
                                color: Colors.deepPurple[200],
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        controller: _controller,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  // IconButton(onPressed: (){
                  //   showBottomSheet(context: context, builder: (BuildContext context){
                  //     return Container();
                  //   });
                  // }, icon: Icon(Icons.history)),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: SingleChildScrollView(
            //       child: Column(
            //
            //         children: [
            //
            //         ],
            //       ),
            //     ),
            //   ),
            //     // child: MessagesScreen(messages: messages)
            // ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            //   color: Colors.deepPurple[50],
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Container(
            //         decoration: BoxDecoration(
            //             border: Border.all(color: Colors.deepPurple),
            //             borderRadius: BorderRadius.circular(20)),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10),
            //           child: TextField(
            //             decoration: InputDecoration(
            //               enabled: true,
            //                 border: InputBorder.none,
            //                 hintText: 'Tap 🎙️ and say "HELLO"',
            //                 hintStyle: TextStyle(
            //                     color: Colors.deepPurple[200],
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w400)),
            //             controller: _controller,
            //             style: TextStyle(color: Colors.black),
            //           ),
            //         ),
            //       )),
            //       SizedBox(
            //         width: 70,height: 70,
            //       ),
            //       // Container(
            //       //   padding: EdgeInsets.all(5),
            //       //   decoration: BoxDecoration(
            //       //       color: Colors.deepPurple,
            //       //       borderRadius: BorderRadius.circular(50)),
            //       //   child: IconButton(
            //       //       onPressed: () {
            //       //         sendMessage(_controller.text);
            //       //         _controller.clear();
            //       //       },
            //       //       icon: Icon(
            //       //         Icons.send,
            //       //         color: Colors.white,
            //       //       )),
            //       // )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
          animate: !_isListening,
          glowRadiusFactor: 1,
          glowColor: Colors.deepPurple,
          duration: Duration(milliseconds: 1000),
          repeat: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FloatingActionButton(
              onPressed: _listen,
              splashColor: !_isListening ? Colors.red : Colors.green,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                !_isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  // dialogflow  //

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({'message': message, 'isUserMessage': isUserMessage});
    });
    if (!isUserMessage) {
      final text = message.text?.text ?? [];
      speak(text[0]);
      print(text[0]);
    }
  }

  // speech to text //

  void _listen() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      final options = SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true,
        sampleRate: 2,
      );
      _speechToText.listen(
          listenOptions: options,
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          });
    } else {
      await _speechToText.stop();
      setState(() {
        sendMessage(_controller.text);
        _controller.clear();
        _isListening = true;
      });
    }
  }
}
