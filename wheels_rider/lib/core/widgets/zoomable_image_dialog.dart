import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZoomableImageDialog extends StatefulWidget {
  final String imagePath;
  final String title;

  const ZoomableImageDialog({
    super.key,
    required this.imagePath,
    this.title = 'Profile Photo',
  });

  static void show(BuildContext context, {required String imagePath, String title = 'Profile Photo'}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => ZoomableImageDialog(
        imagePath: imagePath,
        title: title,
      ),
    );
  }

  @override
  State<ZoomableImageDialog> createState() => _ZoomableImageDialogState();
}

class _ZoomableImageDialogState extends State<ZoomableImageDialog> {
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1.5, -position.dy * 1.5)
        ..scale(2.5);
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              clipBehavior: Clip.none,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: 'profile_pic_hero',
                child: _buildImageWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    final path = widget.imagePath.trim();

    if (path.isEmpty) {
      return Image.asset(
        'assets/images/strive_logo.jpg',
        fit: BoxFit.contain,
      );
    }

    if (kIsWeb || path.startsWith('http://') || path.startsWith('https://') || path.startsWith('blob:')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/strive_logo.jpg',
          fit: BoxFit.contain,
        ),
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.contain,
      );
    }

    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/strive_logo.jpg',
            fit: BoxFit.contain,
          ),
        );
      }
    } catch (_) {}

    return Image.asset(
      'assets/images/strive_logo.jpg',
      fit: BoxFit.contain,
    );
  }
}
