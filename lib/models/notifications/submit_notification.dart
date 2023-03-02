import 'package:flutter/material.dart';

class SubmitNotification<T> extends Notification {
  final T value;

  SubmitNotification(this.value);
}