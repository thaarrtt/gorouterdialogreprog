import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/models/login.dart';
import '../features/products/models/product.dart';
import '../features/profile/models/profile.dart';
import '../features/todos/models/todo.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
class ApiClient extends _$ApiClient {
  @override
  Dio build() => Dio()..options.baseUrl = 'https://dummyjson.com';

  Future<Profile> login(Login data) async {
    final response = await state.post(
      '/auth/login',
      data: data.toJson(),
    );

    return Profile.fromJson(response.data as Map<String, Object?>);
  }

  Future<List<Product>> fetchProducts() async {
    final response = await state.get('/products');

    return (response.data['products'] as List)
        .cast<Map<String, Object?>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await state.get('/todos');

    return (response.data['todos'] as List)
        .cast<Map<String, Object?>>()
        .map(Todo.fromJson)
        .toList();
  }

  Future<Todo> addTodo(Todo todo) async {
    final response = await state.post(
      '/todos/add',
      data: todo.toJson(),
    );

    return Todo.fromJson(response.data as Map<String, Object?>);
  }
}
