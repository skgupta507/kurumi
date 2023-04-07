import 'package:anilist/graphql/__generated__/profile.data.gql.dart';
import 'package:anilist/graphql/__generated__/profile.var.gql.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kurumi/config/app_route_constant.dart';
import 'package:kurumi/config/app_router.dart';

class FavAnimeGridview extends StatelessWidget {
  const FavAnimeGridview({
    super.key,
    required this.size,
    required this.response,
  });

  final Size size;
  final OperationResponse<GProfileData, GProfileVars>? response;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      // height: 300,
      width: size.width,
      child: GridView.builder(
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        // scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = response?.data?.Viewer?.favourites?.anime?.nodes
              ?.elementAt(index);
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                context.pushNamed(
                  AppRouteConstant.MediaScreen.name,
                  params: {
                    'id': (data?.id ?? 0).toString(),
                    'title': data?.title?.english ?? '',
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox.square(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: data?.coverImage?.large ?? '',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount:
            response?.data?.Viewer?.favourites?.anime?.nodes?.length ?? 0,
      ),
    );
  }
}