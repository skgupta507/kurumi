import 'package:flutter/material.dart';

class TrendingNowTitle extends StatelessWidget {
  const TrendingNowTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: RichText(
        text: TextSpan(
          text: 'TRENDING  ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green,
            letterSpacing: 3,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 20,
              )
            ],
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'NOW ',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class PopularThisSeasonTitle extends StatelessWidget {
  const PopularThisSeasonTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: RichText(
        text: TextSpan(
          text: 'POPULAR  ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            // color: Colors.amber,

            letterSpacing: 3,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 20,
              )
            ],
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'THIS  SEASON',
              style: TextStyle(color: Colors.amber),
            )
          ],
        ),
      ),
    );
  }
}

class UpcomingNextSeasonAnimeTitle extends StatelessWidget {
  const UpcomingNextSeasonAnimeTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: RichText(
        text: TextSpan(
          text: 'UPCOMING  NEXT  ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
            letterSpacing: 3,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 20,
              )
            ],
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'SEASON',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class Top100AnimeTitle extends StatelessWidget {
  const Top100AnimeTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: RichText(
        text: TextSpan(
          text: 'TOP  100  ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.redAccent,
            letterSpacing: 3,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 20,
              )
            ],
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'ANIME',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}