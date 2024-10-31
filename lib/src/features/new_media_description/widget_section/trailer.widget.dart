import 'package:anilist/anilist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kurumi/src/core/core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrailerWidget extends StatelessWidget {
  const TrailerWidget({
    super.key,
    required this.data,
    required this.size,
  });

  final GMediaDetailQueryData_Media? data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: data?.trailer != null && (data?.trailer?.site == 'youtube'),
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trailer',
              style: Poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Opacity(
              opacity: 0.9,
              child: CachedNetworkImage(
                imageUrl: data?.trailer?.thumbnail ?? '',
                fit: BoxFit.fitWidth,
                imageBuilder: (context, imageProvider) => GestureDetector(
                  onTap: () {
                    launchUrlString(
                      'https://www.youtube.com/watch?v=${data?.trailer?.id}',
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white70,
                        child: Icon(
                          PhosphorIconsFill.play,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
