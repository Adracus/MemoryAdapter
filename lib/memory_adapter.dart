library memoryadapter;

import 'dart:async' show Future;
import 'package:activerecord/activerecord.dart';

class MemoryAdapter extends DatabaseAdapter {
  Map<String, Table> _tables = {};
  MemoryAdapter(): super(null);
  
  Future<Model> saveModel(Schema schema, Model m) {
    _tables.putIfAbsent(schema.tableName, () => new Table());
    _tables[schema.tableName].add(m);
    return new Future.sync(() => m);
  }
  
  Future<Model> updateModel(Schema schema, Model m) {
    _tables[schema.tableName].update(m);
    return new Future.sync(() => m);
  }
  
  Future<bool> destroyModel(Model m) {
    _tables[m.parent.schema.tableName].remove(m);
    return new Future.sync(() => true);
  }
  
  Future<List<Model>> modelsWhere(Collection c, String sql, List args,
      {int limit, int offset}) {
    throw new UnimplementedError("Memory adapter does not provide this");
  }
  
  Future<bool> createTable(Schema schema) {
    _tables.putIfAbsent(schema.tableName, () => new Table());
    return new Future.sync(() => true);
  }
  
  Future<List<Model>> findModelsByVariables(Collection c,
      Map<Variable, dynamic> variables, {int limit, int offset}) {
    if(!_tables.containsKey(c.schema.tableName)) return new Future.sync(() => []);
    return new Future.sync(() => _tables[c.schema.tableName].where(variables));
  }
  
  Future<bool> addColumnToTable(String tableName, Variable variable) =>
      new Future.sync(() => true);
  
  Future<bool> removeColumnFromTable(String tableName, String variableName) =>
      new Future.sync(() => true);
  
  Future<bool> dropTable(String tableName) {
    _tables.remove(tableName);
    return new Future.sync(() => true);
  }
}

class Table {
  int _idCt = 1;
  Map<int, Model> _rows = {};
  
  List<Model> where(Map<Variable, dynamic> variables) {
    return _rows.values.where((m) {
      bool res = true;
      variables.forEach((v, val) {
        res = res && m[v.name] == val;
      });
      return res;
    }).toList();
  }
  
  void add(Model m) {
    m.id = _idCt;
    _rows[_idCt] = m;
    _idCt++;
  }
  
  void update(Model m) {
    _rows[m.id] = m;
  }
  
  void remove(Model m) {
    _rows.remove(m.id);
  }
}