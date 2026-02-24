
//   return provider.todoList.isNotEmpty
//       ? Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                 ),
//                 child: Text(
//                   '${provider.startIndex}-${provider.endIndex}/${provider.totalCount}',
//                 ),
//               ),
//               IconButton(
//                 icon: HugeIcon(
//                   icon: HugeIcons.strokeRoundedArrowLeft01,
//                   color: provider.canGoPrevious
//                       ? Colors.black
//                 ),
//                 onPressed: provider.canGoPrevious
//                     : null,
//               ),

//               IconButton(
//                 icon: HugeIcon(
//                   icon: HugeIcons.strokeRoundedArrowRight01,
//                   color: provider.canGoNext
//                       ? Colors.black
//                 ),
//                 onPressed: provider.canGoNext
//                     : null,
//               ),
//             ],
//           ),
//         )