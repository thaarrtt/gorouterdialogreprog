import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/product.dart';
import '../providers/products.dart';

/// A screen showing all products in a list view.
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    Future<void> onRefresh() => ref.refresh(productsProvider.future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: products.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('An error occurred')),
          data: (products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) => _ProductListTile(products[index]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/todos');
        },
        tooltip: 'Add todo',
        child: const Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    void onTap() => context.go('/products/${product.id}');

    return ListTile(
      onTap: onTap,
      title: Text(product.title),
      subtitle: product.brand != null ? Text(product.brand!) : null,
    );
  }
}
