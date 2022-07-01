import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_cubit.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_state.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_state_listener.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final qrKey = GlobalKey();
  QRViewController? qrController;
  StreamSubscription<Barcode>? stream;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController?.pauseCamera();
    } else if (Platform.isIOS) {
      qrController?.resumeCamera();
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();
        return true;
      },
      child: BlocListener<QrScannerCubit, QrScannerState>(
        listener: (context, state) => QrScannerStateListener.listenTo(
          context,
          state,
          stream,
          qrController,
        ),
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              getString(context).qr_scanner_title,
              style: GoogleFonts.oxygen(
                fontSize: 18.0,
                color: AppColors.creamWhite,
              ),
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: AppColors.black.withOpacity(0.8),
          ),
          body: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.accent,
              borderRadius: 24.0,
              borderWidth: 12.0,
              borderLength: 50.0,
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;

    try {
      // workaround for bug with black screen
      qrController!.pauseCamera();
      qrController!.resumeCamera();

      stream = qrController!.scannedDataStream
          .listen(context.read<QrScannerCubit>().validateData);
    } catch (_) {
      Navigator.pop(context);
    }
  }
}
