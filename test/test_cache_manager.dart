import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';

class TestCacheManager extends Mock implements BaseCacheManager {
  TestCacheManager();

  factory TestCacheManager.successfulImageLoad(){
    Stream<FileResponse> testGetFileStream(String url,
        {Map<String, String> headers,String key, bool withProgress}) async* {
      yield FileInfo(
        File('test/assets/images/test_poster.jpg'),
        FileSource.Cache,
        DateTime(2050),
        url,
      );
    }
    TestCacheManager testCacheManager = TestCacheManager();
    when(testCacheManager.getFileStream).thenAnswer((realInvocation) =>
    testGetFileStream);
    return testCacheManager;
  }

  Future<String> getFilePath() async {
    return null;
  }

}