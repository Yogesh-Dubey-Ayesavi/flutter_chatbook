import 'dart:math';

import 'package:flutter/material.dart';

import '../../../flutter_chatbook.dart';

class MessageList extends ChangeNotifier implements List<Message> {
  final List<Message> _messages = [];

  @override
  int get length => _messages.length;

  @override
  set length(int newLength) {
    _messages.length = newLength;
  }

  @override
  Message operator [](int index) => _messages[index];

  @override
  void operator []=(int index, Message value) {
    _messages[index] = value;
    notifyListeners(); // Notify listeners whenever an item is changed
  }

  @override
  void add(Message value) {
    _messages.add(value);
    notifyListeners(); // Notify listeners when an item is added
  }

  @override
  void addAll(Iterable<Message> iterable) {
    _messages.addAll(iterable);
    notifyListeners(); // Notify listeners when multiple items are added
  }

  @override
  void clear() {
    _messages.clear();
    notifyListeners(); // Notify listeners when the list is cleared
  }

  @override
  bool any(bool Function(Message) test) => _messages.any(test);

  @override
  bool contains(Object? element) => _messages.contains(element);

  @override
  Message elementAt(int index) => _messages.elementAt(index);

  @override
  bool every(bool Function(Message) test) => _messages.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Message) f) => _messages.expand(f);

  @override
  void fillRange(int start, int end, [Message? fillValue]) {
    _messages.fillRange(start, end, fillValue);
    notifyListeners(); // Notify listeners when a range of items is filled
  }

  @override
  set first(Message value) {
    _messages.first = value;
    notifyListeners(); // Notify listeners when the first item is changed
  }

  @override
  Message get first => _messages.first;

  @override
  Message firstWhere(bool Function(Message) test,
          {Message Function()? orElse}) =>
      _messages.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T, Message) combine) =>
      _messages.fold(initialValue, combine);

  @override
  Iterable<Message> followedBy(Iterable<Message> other) =>
      _messages.followedBy(other);

  @override
  void forEach(void Function(Message) f) => _messages.forEach(f);

  @override
  Iterable<Message> getRange(int start, int end) =>
      _messages.getRange(start, end);

  @override
  int indexOf(Message element, [int start = 0]) =>
      _messages.indexOf(element, start);

  @override
  int indexWhere(bool Function(Message) test, [int start = 0]) =>
      _messages.indexWhere(test, start);

  @override
  void insert(int index, Message element) {
    _messages.insert(index, element);
    notifyListeners(); // Notify listeners when an item is inserted
  }

  @override
  void insertAll(int index, Iterable<Message> iterable) {
    _messages.insertAll(index, iterable);
    notifyListeners(); // Notify listeners when multiple items are inserted
  }

  @override
  String join([String separator = '']) => _messages.join(separator);

  @override
  int lastIndexOf(Message element, [int? start]) =>
      _messages.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(Message) test, [int? start]) =>
      _messages.lastIndexWhere(test, start);

  @override
  set last(Message value) {
    _messages.last = value;
    notifyListeners(); // Notify listeners when the last item is changed
  }

  @override
  Message get last => _messages.last;

  @override
  Message lastWhere(bool Function(Message) test,
          {Message Function()? orElse}) =>
      _messages.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(Message) f) => _messages.map(f);

  @override
  Message get single => _messages.single;

  @override
  Message singleWhere(bool Function(Message) test,
          {Message Function()? orElse}) =>
      _messages.singleWhere(test, orElse: orElse);

  @override
  Iterable<Message> skip(int count) => _messages.skip(count);

  @override
  Iterable<Message> skipWhile(bool Function(Message) test) =>
      _messages.skipWhile(test);

  @override
  void sort([int Function(Message, Message)? compare]) {
    _messages.sort(compare);
    notifyListeners(); // Notify listeners when the list is sorted
  }

  @override
  List<Message> sublist(int start, [int? end]) => _messages.sublist(start, end);

  @override
  Iterable<Message> take(int count) => _messages.take(count);

  @override
  Iterable<Message> takeWhile(bool Function(Message) test) =>
      _messages.takeWhile(test);

  @override
  List<Message> toList({bool growable = true}) =>
      _messages.toList(growable: growable);

  @override
  Set<Message> toSet() => _messages.toSet();

  @override
  Iterable<Message> where(bool Function(Message) test) => _messages.where(test);

  @override
  Iterable<T> whereType<T>() => _messages.whereType<T>();

  // Custom methods

  void updateItem(int index, Message updatedMessage) {
    _messages[index] = updatedMessage;
    notifyListeners(); // Notify listeners when a specific item is changed
  }

  @override
  List<Message> operator +(List<Message> other) {
    _messages.addAll(other);
    notifyListeners();
    return _messages;
  }

  @override
  Map<int, Message> asMap() {
    return _messages.asMap();
  }

  @override
  List<R> cast<R>() {
    return _messages.cast<R>();
  }

  @override
  bool get isEmpty => _messages.isEmpty;

  @override
  bool get isNotEmpty => _messages.isNotEmpty;

  @override
  Iterator<Message> get iterator => _messages.iterator;

  @override
  Message reduce(Message Function(Message value, Message element) combine) {
    return _messages.reduce(combine);
  }

  @override
  bool remove(Object? value) {
    final removed = _messages.remove(value);
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  @override
  Message removeAt(int index) {
    final removed = _messages.removeAt(index);
    notifyListeners();
    return removed;
  }

  @override
  Message removeLast() {
    final removed = _messages.removeLast();
    notifyListeners();
    return removed;
  }

  @override
  void removeRange(int start, int end) {
    _messages.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(Message element) test) {
    _messages.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<Message> replacements) {
    _messages.replaceRange(start, end, replacements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(Message element) test) {
    _messages.retainWhere(test);
    notifyListeners();
  }

  @override
  Iterable<Message> get reversed => _messages.reversed;

  @override
  void setAll(int index, Iterable<Message> iterable) {
    _messages.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<Message> iterable,
      [int skipCount = 0]) {
    _messages.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _messages.shuffle(random);
    notifyListeners();
  }
}
