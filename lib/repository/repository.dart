abstract class Repository<T> {

  Future<int> add(T obj);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
  Future<int> update(T obj);
  Future<int> delete(int id);

}