import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class CustomSpeechToText extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const CustomSpeechToText({super.key, required this.controller, this.focusNode});

  @override
  State<StatefulWidget> createState() => CustomSpeechToTextState();
}

class CustomSpeechToTextState extends State<CustomSpeechToText> {

  final SpeechToText _speechToText = SpeechToText();
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (_speechToText.isNotListening) {
          if (widget.focusNode != null && !widget.focusNode!.hasFocus) {
            widget.focusNode!.requestFocus();
          }
          _startListening(widget.controller);
        }
      },
      onTapUp: (TapUpDetails details) {
        if (_speechToText.isListening) {
          if (widget.focusNode != null && widget.focusNode!.hasFocus) {
            widget.focusNode!.unfocus();
          }
          _stopListening();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          _speechToText.isNotListening ? CupertinoIcons.mic : CupertinoIcons.mic_fill,
          color: _speechToText.isNotListening
              ? Colors.white
              : context.theme.colorScheme.primary,
        ),
      ),
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _startListening(TextEditingController controller) async {
    await _speechToText.listen(
      localeId: "fa_IR",
      // localeId: "en_US",
      partialResults: true,
      cancelOnError: true,
      onSoundLevelChange: _soundLevelListener,
      listenFor: const Duration(seconds: 30),
      onResult: (SpeechRecognitionResult result) {
        setState(() {
          // controller.text += result.finalResult ? ' ${result.recognizedWords}' : '';
          if (result.finalResult) {
            controller.text += result.recognizedWords;
          }
        });
      },
    );
    setState(() {});
  }

  void _soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }
}
