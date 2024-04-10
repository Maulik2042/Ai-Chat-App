import 'dart:developer';
import 'package:ai_chat/models/chat_message_model.dart';
import 'package:ai_chat/utils/constants.dart';
import 'package:dio/dio.dart';

class ChatRepository{
  static Future<String> chatTextGenerationRepo(List<ChatMessageModel> previousMessages) async {
   try {
      Dio dio = Dio();

    final response = await dio.post("Your google Gemini's apiKey"
    ,
    data: {
  "contents": previousMessages.map((e) => e.toMap()).toList(),
     "generationConfig": {
    "temperature": 0.9,
    "topK": 1,
    "topP": 1,
    "maxOutputTokens": 2048,
    "stopSequences": []
  },
  "safetySettings": [
    {
      "category": "HARM_CATEGORY_HARASSMENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_HATE_SPEECH",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    }
  ]
}
    
    );
    if(response.statusCode! >= 200 && response.statusCode! < 300){
      return response.data['candidates'].first['content']['parts'].first['text'];

    } 
    return '';
   } catch (e) {
     log(e.toString());
     return '';
   }
  }

}
