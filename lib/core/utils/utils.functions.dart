// ignore_for_file: dead_code, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

class Col {
  static Color parseHex(String? color, {int? base}) {
    String col = color ?? '#ffffff';
    int colorCode =
        int.parse(col.substring(1, 7), radix: 16) + (base ?? 0xFF000000);
    return Color(colorCode);
  }
}

Widget get LoadingWidget => Center(
      child: LottieBuilder.asset(
        'assets/lotties/loading-gif-animation.json',
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );

showSnackBar(BuildContext context, String text,
        {Duration duration = const Duration(seconds: 2)}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Chip(
          avatar: ClipOval(child: Image.asset('assets/meta/ninja.png')),
          label: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: duration,
        elevation: 0,
      ),
    );

final log = Logger();

String validMarkdown(String? markdown) {
  if (markdown == null) return '';
  RegExp regex = RegExp(r'(img\d+)?\(((?:https?://|/).*?)\)');
  String res = markdown.replaceAllMapped(regex, (match) {
    String imageAlt = match.group(1) ?? '';
    String imageUrl = match.group(2) ?? '';

    return '![$imageAlt]($imageUrl)';
  });
  log.v(res.replaceAll('~', '').replaceAll('_', ''));
  return res.replaceAll('~', '').replaceAll('_', '');
}
