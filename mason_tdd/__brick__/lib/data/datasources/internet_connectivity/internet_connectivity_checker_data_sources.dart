// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '/core/constants/global.dart';
// import '/core/show/show.dart';
// import '/domain/failures/network/network_failure.dart';

// class InternetConnectivityCheckerDataSources extends Cubit<bool> {
//   final Connectivity _connectivity;
//   final Show _show;

//   late final StreamSubscription<List<ConnectivityResult>> _subscription;

//   InternetConnectivityCheckerDataSources(this._connectivity, this._show)
//     : super(false) {
//     _subscription = _connectivity.onConnectivityChanged.listen(
//       (event) => event.first == ConnectivityResult.none
//           ? _show.showNetworkErrorSnackBar(
//               GlobalConstants.navigatorKey.currentContext!,
//               NetworkFailure(error: 'No Internet Connection'),
//             )
//           : GlobalConstants.navigatorKey.currentContext != null
//           ? ScaffoldMessenger.of(
//               GlobalConstants.navigatorKey.currentContext!,
//             ).hideCurrentMaterialBanner()
//           : null,
//     );
//   }

//   @override
//   Future<void> close() {
//     _subscription.cancel();
//     return super.close();
//   }
// }
