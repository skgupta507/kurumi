import 'package:anilist/discover_media.dart';
import 'package:anilist/graphql/__generated__/media_detail_query.data.gql.dart';
import 'package:anilist/graphql/__generated__/media_detail_query.req.gql.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kurumi/config/app_theme.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:kurumi/config/app_route_constant.dart';
import 'package:kurumi/config/app_router.dart';
import 'package:kurumi/main.dart';
import 'package:kurumi/presentation/media_description/widgets/info_tile.widget.dart';
import 'package:kurumi/utils/utils.functions.dart';

class MediaScreen extends ConsumerStatefulWidget {
  MediaScreen({required this.id, required this.title, super.key});
  int id;
  String title;

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer(
        builder: (context, ref, child) {
          final client = ref.watch(clientProvider);
          return Operation(
            client: client!,
            operationRequest: GMediaDetailQueryReq(
              (b) => b
                ..vars.id = widget.id
                ..vars.limit = 5
                ..vars.page = 1
                ..vars.perPage = 10,
            ),
            builder: (context, response, error) {
              if (response == null || response.loading) {
                return Center(
                  child: LottieBuilder.asset(
                    'assets/lotties/loading-gif-animation.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                final data = response.data?.Media;
                Color color = Col.parseHex(data?.coverImage?.color);
                return Container(
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        BannerAppBar(data: data, size: size),
                        SafeArea(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * .20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'coverImage',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: data?.coverImage?.large ??
                                              data?.coverImage?.medium ??
                                              '',
                                          fit: BoxFit.cover,
                                          height: 160,
                                          width: 120,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      height: 160,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '${data?.format?.toString().replaceAll('_', ' ') ?? ''} • ',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${data?.startDate?.year ?? ''} • '),
                                                TextSpan(
                                                    text: data?.status?.name
                                                            .toString()
                                                            .replaceAll(
                                                                '_YET_', ' ') ??
                                                        ''),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width - 180,
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  data?.title?.userPreferred ??
                                                      data?.title?.english ??
                                                      data?.title?.romaji ??
                                                      '',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    color: color,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            onPressed: () {},
                                            child: Text('ADD'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              MediaGenreSection(size: size, data: data),
                              SizedBox(height: 20),
                              MediaDescription(data: data),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CHARACTERS',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 140,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      data?.characters?.edges?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final characterData = data
                                        ?.characters?.edges
                                        ?.elementAt(index)
                                        ?.node;
                                    return Container(
                                      width: 80,
                                      margin: EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              HapticFeedback.mediumImpact();
                                              context.pushNamed(
                                                AppRouteConstant.Character.name,
                                                params: {
                                                  'id': (characterData?.id ?? 0)
                                                      .toString(),
                                                  'name': characterData
                                                          ?.name?.full ??
                                                      '',
                                                },
                                                extra: data?.characters?.edges
                                                    ?.elementAt(index),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Hero(
                                                tag: 'Character',
                                                child: CachedNetworkImage(
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                  imageUrl: characterData
                                                          ?.image?.large ??
                                                      characterData
                                                          ?.image?.medium ??
                                                      '',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            characterData?.name?.full ?? '',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OVERVIEW',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    InfoTile('Romanji', data?.title?.romaji),
                                    InfoTile('English', data?.title?.english),
                                    Divider(),
                                    InfoTile('Format', data?.format?.name),
                                    InfoTile('Episodes', data?.episodes),
                                    InfoTile('Volumes', data?.volumes),
                                    InfoTile('Chapters', data?.chapters),
                                    InfoTile('Duration', data?.duration,
                                        extra: ' min per ep'),
                                    InfoTile('Status', data?.status?.name),
                                    Divider(),
                                    InfoTile('Season', data?.season,
                                        extra: ' ' +
                                            (data?.seasonYear ?? '')
                                                .toString()),
                                    InfoTile('Start At',
                                        '${data?.startDate?.day ?? ''}-${data?.startDate?.month ?? ''}-${data?.startDate?.year ?? ''}'),
                                    InfoTile('End At',
                                        '${data?.endDate?.day ?? ''}-${data?.endDate?.month ?? ''}-${data?.endDate?.year ?? ''}'),
                                    if (data?.type == GMediaType.ANIME)
                                      Divider(),
                                    if (data?.type == GMediaType.ANIME &&
                                        data?.studios?.nodes != null &&
                                        (data?.studios?.nodes?.isNotEmpty ??
                                            false))
                                      Column(
                                        children: [
                                          InfoTile(
                                              'Studio',
                                              data?.studios?.nodes
                                                      ?.elementAt(0)
                                                      ?.name ??
                                                  ''),
                                          if (data?.type == GMediaType.ANIME)
                                            for (int i = 1;
                                                i <
                                                    (data?.studios?.nodes
                                                            ?.length ??
                                                        0);
                                                i++)
                                              InfoTile(
                                                '',
                                                data?.studios?.nodes
                                                    ?.elementAt(i)
                                                    ?.name,
                                              ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              TagSection(data: data),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Relations',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      data?.relations?.nodes?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final relatedAnimeData = data
                                        ?.relations?.nodes
                                        ?.elementAt(index);
                                    return Container(
                                      width: 100,
                                      margin: EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      context.pushNamed(
                                                    AppRouteConstant
                                                        .MediaScreen.name,
                                                    params: {
                                                      'id': (relatedAnimeData
                                                                  ?.id ??
                                                              0)
                                                          .toString(),
                                                      'title': relatedAnimeData
                                                              ?.title
                                                              ?.userPreferred ??
                                                          '',
                                                    },
                                                  ),
                                                  child: CachedNetworkImage(
                                                    height: 130,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                    imageUrl: relatedAnimeData
                                                            ?.coverImage
                                                            ?.large ??
                                                        '',
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    color: Colors.black54,
                                                    child: Center(
                                                      child: Text(
                                                        relatedAnimeData?.format
                                                                ?.name ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          SizedBox(
                                            height: 35,
                                            child: Text(
                                              relatedAnimeData
                                                      ?.title?.userPreferred ??
                                                  '',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Builder(
                                builder: (context) {
                                  final recommendedData =
                                      response.data?.Page?.recommendations;
                                  if ((recommendedData?.length == null) ||
                                      (recommendedData?.length == 0))
                                    return Container();
                                  Size size = MediaQuery.of(context).size;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          'Recommendations',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        child: ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              recommendedData?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final recommendAnimeData =
                                                recommendedData
                                                    ?.elementAt(index)
                                                    ?.mediaRecommendation;
                                            return Container(
                                              width: 100,
                                              margin: EdgeInsets.only(left: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          context.pushNamed(
                                                        AppRouteConstant
                                                            .MediaScreen.name,
                                                        params: {
                                                          'id':
                                                              (recommendAnimeData
                                                                          ?.id ??
                                                                      0)
                                                                  .toString(),
                                                          'title':
                                                              recommendAnimeData
                                                                      ?.title
                                                                      ?.userPreferred ??
                                                                  '',
                                                        },
                                                      ),
                                                      child: CachedNetworkImage(
                                                        height: 130,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            recommendAnimeData
                                                                    ?.coverImage
                                                                    ?.large ??
                                                                '',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  SizedBox(
                                                    height: 35,
                                                    child: Text(
                                                      recommendAnimeData?.title
                                                              ?.userPreferred ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'External Links',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 35,
                                width: size.width,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: data?.externalLinks?.length ?? 0,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    String col = data?.externalLinks
                                            ?.elementAt(i)
                                            ?.color
                                            ?.toString() ??
                                        '#ffffff';
                                    Color iconColor = Color(int.parse(
                                            col.substring(1, 7),
                                            radix: 16) +
                                        0xFF000000);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white30,
                                            foregroundColor: iconColor,
                                            side: BorderSide(color: iconColor)),
                                        icon: CachedNetworkImage(
                                          color: iconColor,
                                          imageUrl: data?.externalLinks
                                                  ?.elementAt(i)
                                                  ?.icon ??
                                              '',
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.web,
                                            color: iconColor,
                                          ),
                                          memCacheHeight: 25,
                                          memCacheWidth: 25,
                                        ),
                                        onPressed: () {
                                          launchUrlString(
                                            data?.externalLinks
                                                    ?.elementAt(i)
                                                    ?.url ??
                                                '',
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        },
                                        label: Text(
                                          data?.externalLinks
                                                  ?.elementAt(i)
                                                  ?.site ??
                                              '',
                                          style: TextStyle(shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1)
                                          ]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class MediaDescription extends StatefulWidget {
  const MediaDescription({
    super.key,
    required this.data,
  });

  final GMediaDetailQueryData_Media? data;

  @override
  State<MediaDescription> createState() => _MediaDescriptionState();
}

class _MediaDescriptionState extends State<MediaDescription> {
  bool showDescription = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => setState(() => showDescription = !showDescription),
        child: Column(
          children: [
            Text(
              widget.data?.description
                      ?.replaceAll('<br><br>', '\n')
                      .replaceAll('<br>', '\n')
                      .replaceAll('<b>', '')
                      .replaceAll('</b>', '')
                      .replaceAll('<i>', '')
                      .replaceAll('</i>', '')
                      .replaceAll('\n\n', '\n') ??
                  '',
              textAlign: TextAlign.justify,
              maxLines: showDescription ? null : 7,
            ),
            Icon(
              showDescription ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class MediaGenreSection extends StatelessWidget {
  const MediaGenreSection({
    super.key,
    required this.size,
    required this.data,
  });

  final Size size;
  final GMediaDetailQueryData_Media? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: size.width,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          for (int i = 0; i < (data?.genres?.length ?? 0); i++)
            Builder(
              builder: (context) => Card(
                margin: EdgeInsets.only(
                  right: 8,
                  bottom: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(data?.genres?.elementAt(i) ?? '#'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BannerAppBar extends StatelessWidget {
  const BannerAppBar({
    super.key,
    required this.data,
    required this.size,
  });

  final GMediaDetailQueryData_Media? data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CachedNetworkImage(
              imageUrl: data?.bannerImage ??
                  data?.coverImage?.extraLarge ??
                  data?.coverImage?.large ??
                  data?.coverImage?.medium ??
                  '',
              width: size.width,
              height: size.height * .4,
              fit: data?.bannerImage != null
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
            ),
            Container(
              width: size.width,
              height: size.height * .4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.background.withOpacity(.1),
                    AppTheme.background.withOpacity(.7),
                    AppTheme.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              child: Container(
                height: 10,
                width: size.width,
                color: AppTheme.background,
              ),
              bottom: -5,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${data?.favourites ?? 0}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                          )
                        ]),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {},
                    icon: LineIcon.heartAlt(size: 25),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TagSection extends StatefulWidget {
  const TagSection({
    super.key,
    required this.data,
  });

  final GMediaDetailQueryData_Media? data;

  @override
  State<TagSection> createState() => _TagSectionState();
}

class _TagSectionState extends State<TagSection> {
  bool showSpoiler = false;
  @override
  Widget build(BuildContext context) {
    final tagData = widget.data?.tags?.asList();

    if (tagData == null) return Container();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TAGS',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => setState(() => showSpoiler = !showSpoiler),
                child: Text(
                  showSpoiler ? 'Hide Spoilers' : 'Show Spoilers',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: !showSpoiler ? Colors.redAccent : Colors.amber,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        // * TAG SECTION
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 20),
              for (int index = 0;
                  index < (widget.data?.tags?.length ?? 0);
                  index++)
                Builder(builder: (context) {
                  bool isSpoiler =
                      (widget.data?.tags?.elementAt(index)?.isMediaSpoiler ??
                          false);
                  if (isSpoiler && !showSpoiler) return Card();
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white24,
                        )),
                    child: Text(
                      '${widget.data?.tags?[index]?.name ?? ''}  ${widget.data?.tags?[index]?.rank ?? '0'}%',
                      style: TextStyle(color: isSpoiler ? Colors.amber : null),
                    ),
                  );
                }),
              SizedBox(width: 20),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
