//
// /// Bottom sheet for selecting a product with API-based fetching, pagination, and search.
//
//
//   static Future<Map<String, dynamic>?> show(
//     String title = 'Select Product',
//     return showModalBottomSheet<Map<String, dynamic>>(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       backgroundColor: Colors.transparent,
//
//   @override
//   State<ProductSelectorBottomSheet> createState() =>
//
// class _ProductSelectorBottomSheetState
//
//
//
//   @override
//
//   @override
//
//     if (_scrollController.position.pixels >=
//
//
//       final products = await _service.fetchProducts(
//         searchQuery: _query.isEmpty ? null : _query,
//         limit: _limit,
//         offset: 0,
//
//
//
//
//       final moreProducts = await _service.fetchProducts(
//         searchQuery: _query.isEmpty ? null : _query,
//         limit: _limit,
//         offset: _offset,
//
//
//
//
//   @override
//
//     return DraggableScrollableSheet(
//       initialChildSize: 0.9,
//       minChildSize: 0.6,
//       maxChildSize: 0.95,
//       expand: false,
//         return Container(
//           decoration: BoxDecoration(
//           ),
//           child: Column(
//             children: [
//               // Drag handle
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey[600] : Colors.grey[300],
//                 ),
//               ),
//
//               // Header
//               Padding(
//                 child: Row(
//                   children: [
//
//                     Icon(
//                       HugeIcons.strokeRoundedPackage,
//                       color: theme.primaryColor,
//                       size: 24,
//                     ),
//                     Expanded(
//                       child: Text(
//                         widget.title,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? Colors.white
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         HugeIcons.strokeRoundedCancel01,
//                         color: isDark ? Colors.white70 : Colors.black87,
//                       ),
//                       style: IconButton.styleFrom(
//                         backgroundColor: isDark
//                             ? Colors.grey[50]
//                             : Colors.grey[50],
//                         shape: RoundedRectangleBorder(
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Search
//               Padding(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
//                     ),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: _onSearchChanged,
//                     autofocus: false,
//                     style: TextStyle(
//                       color: isDark ? Colors.white : Colors.black87,
//                       fontSize: 14,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Search products by name, code or barcode...',
//                       hintStyle: TextStyle(
//                         color: isDark ? Colors.grey[400] : Colors.grey[500],
//                         fontSize: 14,
//                       ),
//                       prefixIcon: Icon(
//                         HugeIcons.strokeRoundedSearch01,
//                         size: 20,
//                         color: isDark ? Colors.grey[400] : Colors.grey[600],
//                       ),
//                       suffixIcon: _isSearching
//                           ? Padding(
//                               child: SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     theme.primaryColor,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : _searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(
//                                 HugeIcons.strokeRoundedCancel01,
//                                 color: isDark
//                                     ? Colors.grey[400]
//                                     : Colors.grey[600],
//                                 size: 20,
//                               ),
//                               },
//                             )
//                           : null,
//                       filled: true,
//                       fillColor: Colors.transparent,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 12,
//                       ),
//                       border: InputBorder.none,
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: theme.primaryColor,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Result count
//               Padding(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     _isLoading
//                         ? 'Loading...'
//                         : '${_products.length} ${_products.length == 1 ? 'product' : 'products'} found',
//                     style: TextStyle(
//                       color: isDark ? Colors.grey[400] : Colors.grey[600],
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//
//               // List
//             ],
//           ),
//       },
//
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             LoadingAnimationWidget.fourRotatingDots(
//               color: isDark
//                   ? Colors.white
//               size: 40,
//             ),
//             Text(
//                   : 'Loading products...',
//             ),
//           ],
//         ),
//
//
//
//     return ListView.builder(
//       controller: _scrollController,
//           return Padding(
//             child: Center(
//               child:SizedBox(
//                 width: 16,
//                 height: 16,
//             ),
//
//         return _ProductTile(
//           product: p,
//           isDark: isDark,
//           },
//       },
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             HugeIcons.strokeRoundedAlertCircle,
//             size: 64,
//             color: isDark ? Colors.grey[700] : Colors.grey[300],
//           ),
//           Text(
//             'Error loading products',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.grey[400] : Colors.grey[600],
//             ),
//           ),
//           Padding(
//             child: Text(
//               _error ?? 'Unknown error',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.grey[500] : Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           ElevatedButton.icon(
//             onPressed: _loadInitialProducts,
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             HugeIcons.strokeRoundedPackageOutOfStock,
//             size: 64,
//             color: isDark ? Colors.grey[700] : Colors.grey[300],
//           ),
//           Text(
//             'No products found',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.grey[400] : Colors.grey[600],
//             ),
//           ),
//           Text(
//             _query.isNotEmpty
//                 ? 'Try adjusting your search'
//                 : 'No products available',
//             style: TextStyle(
//               fontSize: 14,
//               color: isDark ? Colors.grey[500] : Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//
//   Future<Map<String, dynamic>?> _showQuantityDialog(
//     BuildContext context,
//     Map<String, dynamic> product,
//     final TextEditingController priceCtrl = TextEditingController(
//
//
//     return showDialog<Map<String, dynamic>>(
//       context: context,
//         return Dialog(
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//           ),
//           child: Container(
//             child: Form(
//               key: formKey,
//               child: StatefulBuilder(
//
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       Row(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                             ),
//                             child: Icon(
//                               HugeIcons.strokeRoundedPackageAdd,
//                               color: theme.primaryColor,
//                               size: 20,
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Add Product',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 18,
//                                     color: isDark
//                                         ? Colors.white
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                                 Text(
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: isDark
//                                         ? Colors.grey[400]
//                                         : Colors.grey[600],
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       // Input fields
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: _InputField(
//                               label: 'Quantity',
//                               controller: qtyCtrl,
//                               isDark: isDark,
//                               },
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: _InputField(
//                               label: 'Unit Price',
//                               controller: priceCtrl,
//                               isDark: isDark,
//                                 if (price == null || price < 0)
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       // Total display
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             Text(
//                               style: TextStyle(
//                                 color: theme.primaryColor,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextButton(
//                               style: TextButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                 ),
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   color: isDark
//                                       ? Colors.white70
//                                       : theme.primaryColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: qty > 0
//                                           'product': product,
//                                           'quantity': qty,
//                                           'unit_price': price,
//                                   : null,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: theme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: const Text(
//                                 'Add',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                 },
//               ),
//             ),
//           ),
//       },
//
//
//     required this.product,
//     required this.isDark,
//     required this.onTap,
//
//
//   @override
//
//
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey[850] : Colors.white,
//           border: Border.all(
//           ),
//           boxShadow: [
//             if (!isDark)
//               BoxShadow(
//                 blurRadius: 16,
//                 spreadRadius: 2,
//               ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product image
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.grey[800] : Colors.grey[100],
//               ),
//               child: ClipRRect(
//                 child: imageBytes != null
//                     ? Image.memory(
//                         imageBytes,
//                         fit: BoxFit.cover,
//                           return Icon(
//                             HugeIcons.strokeRoundedPackage,
//                             color: isDark ? Colors.grey[600] : Colors.grey[400],
//                             size: 28,
//                         },
//                       )
//                     : Icon(
//                         HugeIcons.strokeRoundedPackage,
//                         color: isDark ? Colors.grey[600] : Colors.grey[400],
//                         size: 28,
//                       ),
//               ),
//             ),
//
//             // Product details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           name,
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             color: isDark ? Colors.white : Colors.black87,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                         Text(
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: theme.primaryColor,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 6,
//                     children: [
//                       if (defaultCode != null &&
//                       if (category != null)
//                       _badge(
//                         context,
//                         qtyAvailable > 0
//                             ? 'In Stock ($qtyAvailable)'
//                             : 'Out of Stock',
//                         isDark,
//                         tint: qtyAvailable > 0 ? Colors.green : Colors.red,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//
//     return Container(
//       decoration: BoxDecoration(
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: fontsize,
//           color: isDark ? Colors.grey[300] : tint,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//
//
//     required this.label,
//     required this.controller,
//     required this.isDark,
//     this.onChanged,
//     this.validator,
//
//   @override
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.grey[300] : Colors.grey[700],
//           ),
//         ),
//         TextFormField(
//           controller: controller,
//           onChanged: onChanged,
//           validator: validator,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.white : Colors.black87,
//           ),
//           decoration: InputDecoration(
//             filled: true,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 14,
//             ),
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//             ),
//             errorBorder: OutlineInputBorder(
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//             ),
//           ),
//         ),
//       ],
