MemoryAdapter for ActiveRecord
============
This is an In-Memory adapter for the [ActiveRecord implementation](https://github.com/Adracus/ActiveRecord)
in dart.

### Why an in-memory adapter?
This adapter is for quick testing purposes only. It does not (really) support
migrations, but it simulates a database adapter by enabling all important
interface methods. The `where`-method throws an exception, accessing data
is only possible via the `findByVariable` method.