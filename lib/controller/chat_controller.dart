import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  RxBool isEdit = false.obs;
  RxBool isEditable = true.obs;
  RxBool isEmojiPickerVisible = false.obs;
  FocusNode focusNode = FocusNode();

  void reset() {
    isEdit.value = false;
  }

  void changeEdit() {
    isEdit.value = !isEdit.value;
  }

  bool checkEditable(DateTime messageTime, DateTime now) {
    return isEditable.value = now.difference(messageTime).inMinutes < 15;
  }

  void openEmojiPicker() {
    isEmojiPickerVisible.value = !isEmojiPickerVisible.value;
    if (isEmojiPickerVisible.value) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
    }
  }

  void closeEmojiPicker() {
    isEmojiPickerVisible.value = false;
  }
}
