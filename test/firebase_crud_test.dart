import 'package:firebase_crud/example/init_data_sources.dart';
import 'package:firebase_crud/example/model/model_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('crud test', () {
    final InitDataSources dataSources = InitDataSources();

    final String uuid = const Uuid().v4();
    const email = 'example@company.com';
    const fullName = 'userFullName';
    dataSources.id = const Uuid().v4();
    dataSources.forTesting = true;

    dataSources.object = ModelExample(
      id: uuid,
      email: email,
      fullName: fullName,
    );
    tearDownAll(() {});
    test('add data test', () async {
      expect(
        () async => await dataSources.add(data: {}),
        isA<void>(),
      );
    });
  });
}
