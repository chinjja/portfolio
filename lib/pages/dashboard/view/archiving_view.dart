import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ArchivingView extends HookConsumerWidget {
  const ArchivingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverStack(
      children: [
        SliverPositioned.fill(
          child: Container(
            color: Colors.grey[900],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 60,
          ),
          sliver: MultiSliver(
            children: [
              SliverToBoxAdapter(
                child: LinkTitle(
                  'ARCHIVING',
                  color: Colors.white,
                  parent: context,
                ),
              ),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 1000,
                child: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 700,
                    crossAxisSpacing: 30,
                    mainAxisExtent: 230,
                    mainAxisSpacing: 20,
                  ),
                  delegate: SliverChildListDelegate.fixed(
                    [
                      _github(),
                      _boj(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _base({
    required String image,
    required String imageLabel,
    required String url,
    required Widget summary,
    required List<String> texts,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 400,
        height: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      image,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      imageLabel,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Linkify(
                  text: url,
                  onOpen: (link) async {
                    if (await canLaunchUrlString(link.url)) {
                      await launchUrlString(link.url);
                    }
                  },
                ),
                const SizedBox(height: 16),
                summary,
                const SizedBox(height: 12),
                ...texts.map(
                  (text) => Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _github() {
    return _base(
      image: 'assets/logos/github.png',
      imageLabel: 'GitHub',
      url: 'http://github.com/chinjja',
      summary: RichText(
        text: const TextSpan(
          text: '소스 코드 저장소',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '입니다.',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      texts: [
        '개인 프로젝트, 프로그램, 앱의 소스 코드',
        '혼자서 코딩 연습을 위해 끄적이던 소스 코드',
      ],
    );
  }

  Widget _boj() {
    return _base(
      image: 'assets/logos/boj.png',
      imageLabel: 'BOJ',
      url: 'http://www.acmicpc.net/user/chinjja',
      summary: RichText(
        text: const TextSpan(
          text: '소스 코드 저장소',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '입니다.',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      texts: [
        '알고리즘 풀이 코드',
      ],
    );
  }
}
