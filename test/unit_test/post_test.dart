import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rndroma/unit_test/post.dart';

class MockClient extends Mock implements http.Client {}

main() {
  group('fetchPost', () {
    test('return Post if the http call completed successfully', () async {
      final client = MockClient();
      // use mockito for success when it calls
      when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
          .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

      expect(await fetchPost(client), isA<Post>());
    });

    test('throw an exception if the http call completes with an error', () async {
      final client = MockClient();
      when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(await fetchPost(client), throwsException);
    });
  });
}
