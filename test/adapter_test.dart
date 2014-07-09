import '../lib/memory_adapter.dart';
import 'package:activerecord/activerecord.dart';
import 'package:unittest/unittest.dart';
import 'dart:async' show Future;

final _adapter = new MemoryAdapter();

class TestCollection extends Collection {
  get variables => ["name", "comment"];
  get adapter => _adapter;
}

main() {
  var tc = new TestCollection();
  
  test("Test model saving", () {
    var m = tc.nu;
    m["name"] = "A new model";
    m["comment"] = "Could this be in memory";
    m.save().then(expectAsync((saved) {
      expect(saved.name, equals("A new model"));
      expect(saved.comment, equals("Could this be in memory"));
    }));
  });
  
  test("Test model finding", () {
    var m = tc.nu;
    m["name"] = "Please find me";
    m["comment"] = "I'm easy to find";
    m.save().then(expectAsync((_) {
      tc.findByVariable({"name": "Please find me"}).then(expectAsync((models) {
        expect(models.first.name, equals("Please find me"));
        expect(models.first.comment, equals("I'm easy to find"));
      }));
    }));
  });
}