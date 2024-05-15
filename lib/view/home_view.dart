import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:product_list/models/product_model.dart';
import 'package:product_list/view_model/products_view_model.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text('Product Listing'),
        ),
        body: Consumer<ProductsViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.hasError) {
              return Center(
                child: Text('Error: ${viewModel.errorMessage}'),
              );
            } else if (viewModel.products.isEmpty) {
              return const Center(child: Text('No products found'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 40),
                        itemCount: viewModel.products.length,
                        itemBuilder: (context, index) {
                          final product = viewModel.products[index];
                          return ProductItem(product: product);
                        },
                      ),
                      onNotification: (notification) {
                        if (notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent) {
                          viewModel.fetchMore(context);

                          return false;
                        }
                        return false;
                      },
                    ),
                  ),
                  if (viewModel.isMoreLoading)
                    LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final ProductModel product;

  const ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(product.image ?? ''),
                      fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? 'No Title',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                Text('\$${product.price}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
                Text('\$${product.type}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
