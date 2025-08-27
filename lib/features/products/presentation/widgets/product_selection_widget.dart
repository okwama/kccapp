import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../providers/products_providers.dart';

class ProductSelectionWidget extends ConsumerStatefulWidget {
  final String label;
  final String? hint;
  final ProductModel? selectedProduct;
  final Function(ProductModel?) onProductSelected;
  final bool isRequired;

  const ProductSelectionWidget({
    super.key,
    required this.label,
    this.hint,
    this.selectedProduct,
    required this.onProductSelected,
    this.isRequired = false,
  });

  @override
  ConsumerState<ProductSelectionWidget> createState() =>
      _ProductSelectionWidgetState();
}

class _ProductSelectionWidgetState
    extends ConsumerState<ProductSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.selectedProduct?.productName ?? '';
    // Use Future.microtask to avoid modifying provider during build cycle
    Future.microtask(() => _loadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    await ref.read(productsNotifierProvider.notifier).fetchAllProducts();
  }

  void _filterProducts(String query) {
    final productsState = ref.read(productsNotifierProvider);
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = productsState.products;
      });
    } else {
      setState(() {
        _filteredProducts = productsState.products
            .where((product) =>
                product.productName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.productCode.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Search/Display Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.hint ?? 'Search products...',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(_isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        _isDropdownOpen = !_isDropdownOpen;
                        if (_isDropdownOpen) {
                          _filteredProducts = productsState.products;
                        }
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  _filterProducts(value);
                  if (value.isEmpty) {
                    widget.onProductSelected(null);
                  }
                },
                onTap: () {
                  setState(() {
                    _isDropdownOpen = true;
                    _filteredProducts = productsState.products;
                  });
                },
              ),
              // Dropdown List
              if (_isDropdownOpen && _filteredProducts.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          product.productName,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Code: ${product.productCode}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        onTap: () {
                          setState(() {
                            _searchController.text = product.productName;
                            _isDropdownOpen = false;
                          });
                          widget.onProductSelected(product);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        if (productsState.isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Loading products...', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        if (productsState.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              productsState.error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
