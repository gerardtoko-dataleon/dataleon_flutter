import 'package:flutter/material.dart';
import 'dataleon_webview.dart';


class Dataleon {
  static const String statusDone = 'FINISHED';
  static const String statusCanceled = 'CANCELED';
  static const String statusError = 'ERROR';
  static const String statusStarted = 'STARTED';
  static const String statusFailed = 'FAILED';

  /// Launch modal
  static void launch({
    required BuildContext context,
    required String sessionUrl,
    required DataleonResultCallback onResult,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DataleonWebView(
            sessionUrl: sessionUrl,
            onResult: (status, [error]) {
              onResult(status, error);
              if (status == statusDone || status == statusCanceled) {
                closeModal(context);
              }
            },
            onClose: () => closeModal(context),
          ),
        ),
      ),
    );
  }

  /// Close the Dataleon modal if open
  static void closeModal(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
