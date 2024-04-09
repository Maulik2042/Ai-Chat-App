import 'dart:async';

import 'package:ai_chat/models/chat_message_model.dart';
import 'package:ai_chat/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);

  }
  List<ChatMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(ChatMessageModel(role: 'user', parts: [
      ChatPartModel(text: event.inputMessage)
    ]));
    emit(ChatSuccessState(messages: messages));
    generating = true;
    String generatedText =  await ChatRepository.chatTextGenerationRepo(messages);
    if(generatedText.length > 0){
      messages.add(ChatMessageModel(role: 'model', parts: [
        ChatPartModel(text: generatedText)
      ]));
      emit(ChatSuccessState(messages: messages));
    }
    generating = false;
  }
}
