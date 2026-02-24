import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class SelectedItemWidget extends StatelessWidget {
  final String? imageFile;
  final bool showImage;
  final String title;
  final VoidCallback? onRemove;

  const SelectedItemWidget({
    super.key,
    this.imageFile,
    required this.onRemove,
    required this.showImage,
    required this.title,
  });

  Uint8List? _decodeBase64(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    try {
      final clean = value.contains(',')
          ? value.split(',').last
          : value;
      final bytes = base64Decode(clean);
      return bytes.isNotEmpty ? bytes : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageBytes =
        showImage ? _decodeBase64(imageFile) : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showImage)
          CircleAvatar(
            radius: 10,
            backgroundColor: ColorConstants.mainWhite,
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _initialText();
                      },
                    )
                  : _initialText(),
            ),
          ),
        Text(
          title,
          style: const TextStyle(
            color: ColorConstants.mainBlack,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: onRemove,
          child:  CircleAvatar(
            radius: 9,
            backgroundColor: Colors.black54,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              color: ColorConstants.mainWhite,
              size: 15
            ),
          ),
        ),
      ],
    );
  }

  Widget _initialText() {
    return Center(
      child: Text(
        title.isNotEmpty ? title[0].toUpperCase() : '',
        style:  TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
