// // lib/core/services/dynamic_links_service.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//
// class DynamicLinksService {
//   static void init(GlobalKey<NavigatorState> navigatorKey) {
//     FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
//       final Uri? deepLink = data.link;
//       if (deepLink != null) {
//         final productId = deepLink.queryParameters['productId'] ?? deepLink.queryParameters['id'];
//         if (productId != null) {
//           navigatorKey.currentState?.pushNamed('/product', arguments: int.tryParse(productId));
//         }
//       }
//     }).onError((e) {
//       // handle error
//     });
//
//     // initial link when app opens from terminated state
//     FirebaseDynamicLinks.instance.getInitialLink().then((data) {
//       final Uri? deepLink = data?.link;
//       if (deepLink != null) {
//         final productId = deepLink.queryParameters['productId'] ?? deepLink.queryParameters['id'];
//         if (productId != null) {
//           navigatorKey.currentState?.pushNamed('/product', arguments: int.tryParse(productId));
//         }
//       }
//     });
//   }
// }
