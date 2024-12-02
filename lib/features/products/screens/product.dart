import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/product.dart';

/// A screen showing a product with the specific [id].
class ProductScreen extends ConsumerWidget {
  const ProductScreen(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: product.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('An error occurred')),
        data: (product) {
          final records = [
            (label: 'Title', text: product.title),
            (label: 'Description', text: product.description),
            if (product.brand != null) (label: 'Brand', text: product.brand!),
            (label: 'Stock', text: product.stock.toString()),
          ];
          return Column(
            children: [
              SizedBox(
                height: 0.6.sh,
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (_, index) {
                    final record = records[index];
                    return ListTile(
                      title: Text(record.label),
                      subtitle: Text(record.text),
                    );
                  },
                ),
              ),
              SizedBox(height: 0.02.sh),
              ListTile(
                title: const Text('test dialog'),
                subtitle: const Text('smart dialog router'),
                onTap: () {
                  SmartDialog.show(builder: (context) {
                    return Container(
                      height: 80,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text('easy custom dialog',
                          style: TextStyle(color: Colors.white)),
                    );
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
