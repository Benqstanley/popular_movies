import 'dart:io' as io;
import 'dart:convert';

import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';

class TestCacheManager extends Mock implements BaseCacheManager {
  TestCacheManager();

  factory TestCacheManager.successfulImageLoad() {

    TestCacheManager testCacheManager = TestCacheManager();
    when(testCacheManager.getFileStream(
      any,
      headers: anyNamed("headers"),
      key: anyNamed("key"),
      withProgress: anyNamed("withProgress"),
    )).thenAnswer((realInvocation) {
      String url = realInvocation.positionalArguments.first.toString();
      return Stream.fromIterable([FileInfo(
        TestFile('test/assets/images/test_poster.jpg'),
        FileSource.Cache,
        DateTime(2050),
        url,
      )
      ]);
    });
    return testCacheManager;
  }

  Future<String> getFilePath() async {
    return null;
  }
}
class TestFile extends File{
  String url;
  TestFile(this.url);

  @override
  // TODO: implement absolute
  File get absolute => throw UnimplementedError();

  @override
  // TODO: implement basename
  String get basename => throw UnimplementedError();

  @override
  Future<File> copy(String newPath) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  File copySync(String newPath) {
    // TODO: implement copySync
    throw UnimplementedError();
  }

  @override
  Future<File> create({bool recursive = false}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  void createSync({bool recursive = false}) {
    // TODO: implement createSync
  }

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  void deleteSync({bool recursive = false}) {
    // TODO: implement deleteSync
  }

  @override
  // TODO: implement dirname
  String get dirname => throw UnimplementedError();

  @override
  Future<bool> exists() {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  bool existsSync() {
    // TODO: implement existsSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement fileSystem
  FileSystem get fileSystem => throw UnimplementedError();

  @override
  // TODO: implement isAbsolute
  bool get isAbsolute => throw UnimplementedError();

  @override
  Future<DateTime> lastAccessed() {
    // TODO: implement lastAccessed
    throw UnimplementedError();
  }

  @override
  DateTime lastAccessedSync() {
    // TODO: implement lastAccessedSync
    throw UnimplementedError();
  }

  @override
  Future<DateTime> lastModified() {
    // TODO: implement lastModified
    throw UnimplementedError();
  }

  @override
  DateTime lastModifiedSync() {
    // TODO: implement lastModifiedSync
    throw UnimplementedError();
  }

  @override
  Future<int> length() {
    // TODO: implement length
    throw UnimplementedError();
  }

  @override
  int lengthSync() {
    // TODO: implement lengthSync
    throw UnimplementedError();
  }

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
    // TODO: implement open
    throw UnimplementedError();
  }

  @override
  Stream<List<int>> openRead([int start, int end]) {
    // TODO: implement openRead
    throw UnimplementedError();
  }

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) {
    // TODO: implement openSync
    throw UnimplementedError();
  }

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
    // TODO: implement openWrite
    throw UnimplementedError();
  }

  @override
  // TODO: implement parent
  Directory get parent => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  Future<Uint8List> readAsBytes() {
    // TODO: implement readAsBytes
    throw UnimplementedError();
  }

  @override
  Uint8List readAsBytesSync() {
    // TODO: implement readAsBytesSync
    throw UnimplementedError();
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) {
    // TODO: implement readAsLines
    throw UnimplementedError();
  }

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) {
    // TODO: implement readAsLinesSync
    throw UnimplementedError();
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    // TODO: implement readAsString
    throw UnimplementedError();
  }

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    // TODO: implement readAsStringSync
    throw UnimplementedError();
  }

  @override
  Future<File> rename(String newPath) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  File renameSync(String newPath) {
    // TODO: implement renameSync
    throw UnimplementedError();
  }

  @override
  Future<String> resolveSymbolicLinks() {
    // TODO: implement resolveSymbolicLinks
    throw UnimplementedError();
  }

  @override
  String resolveSymbolicLinksSync() {
    // TODO: implement resolveSymbolicLinksSync
    throw UnimplementedError();
  }

  @override
  Future setLastAccessed(DateTime time) {
    // TODO: implement setLastAccessed
    throw UnimplementedError();
  }

  @override
  void setLastAccessedSync(DateTime time) {
    // TODO: implement setLastAccessedSync
  }

  @override
  Future setLastModified(DateTime time) {
    // TODO: implement setLastModified
    throw UnimplementedError();
  }

  @override
  void setLastModifiedSync(DateTime time) {
    // TODO: implement setLastModifiedSync
  }

  @override
  Future<FileStat> stat() {
    // TODO: implement stat
    throw UnimplementedError();
  }

  @override
  FileStat statSync() {
    // TODO: implement statSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement uri
  Uri get uri => throw UnimplementedError();

  @override
  Stream<FileSystemEvent> watch({int events = FileSystemEvent.all, bool recursive = false}) {
    // TODO: implement watch
    throw UnimplementedError();
  }

  @override
  Future<File> writeAsBytes(List<int> bytes, {FileMode mode = io.FileMode.write, bool flush = false}) {
    // TODO: implement writeAsBytes
    throw UnimplementedError();
  }

  @override
  void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
    // TODO: implement writeAsBytesSync
  }

  @override
  Future<File> writeAsString(String contents, {FileMode mode = io.FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    // TODO: implement writeAsString
    throw UnimplementedError();
  }

  @override
  void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    // TODO: implement writeAsStringSync
  }

}
