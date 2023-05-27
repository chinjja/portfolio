import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProjectsPage extends HookConsumerWidget {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final floatingShow = useState(false);
    useEffect(() {
      controller.addListener(() {
        floatingShow.value = controller.offset > 300;
      });
      return null;
    }, []);

    final isOwner = ref.watch(isOwnerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("PJH's Portfolio👋"),
        actions: [
          if (isOwner)
            IconButton(
              onPressed: () {
                context.go('/projects/add');
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: const [
          Projects(),
        ],
      ),
      floatingActionButton: floatingShow.value
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.ease,
                );
              },
            )
          : null,
    );
  }
}

class Projects extends StatelessWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slivers = [
      _item(
        context,
        title: '어부바 리뉴얼',
        subtitle: '2023.2 ~ 2023.4 (1인 프로젝트)',
        readme: 'assets/projects/eobuba/README.md',
        images: [
          'assets/projects/eobuba/1.jpg',
          'assets/projects/eobuba/2.jpg',
          'assets/projects/eobuba/3.jpg',
          'assets/projects/eobuba/4.jpg',
          'assets/projects/eobuba/5.jpg',
          'assets/projects/eobuba/6.jpg',
          'assets/projects/eobuba/7.jpg',
          'assets/projects/eobuba/8.jpg',
          'assets/projects/eobuba/9.jpg',
          'assets/projects/eobuba/10.jpg',
          'assets/projects/eobuba/11.jpg',
          'assets/projects/eobuba/12.jpg',
          'assets/projects/eobuba/13.jpg',
        ],
        description: '기존 어부바가 앱 및 서버의 버그가 많아서 전체 리뉴얼하게 되었습니다.\n\n'
            '앱단은 Flutter로 제작하여 AOS와 iOS, Web 모두 지원하게 했습니다.\n'
            '백단은 Spring Boot로 제작하였습니다.\n\n'
            'Stomp을 활용해서 양방향 실시간 정보 교환이 되도록 구성.\n'
            '다중접속시에도 원활히 FCM 알림 가도록 구성.\n\n'
            '- 관리자/원장/선생님/학부모 별 권한 및 화면 구성.\n'
            '- 도착 전 알림.\n'
            '- 실시간 위치 공유.\n'
            '- 스마트 차량 지도.\n\n'
            '50 페이지 이상으로 구성되어 있습니다.\n\n'
            '테스트 계정: xxalflaxx@naver.com\n'
            '테스트 비번: 12345678',
        features: {
          'Frontend': 'Flutter, Riverpod, Fcm, Stomp',
          'Backend': 'Spring Boot, Maria db, Jpa, Security, JWT, Stomp',
          '주요기능': '스마트 차량 지도, 전자 출결',
          'Adnroid':
              'https://play.google.com/store/apps/details?id=com.joyblock.abuba',
          'iOS':
              'https://apps.apple.com/kr/app/%EC%96%B4%EB%B6%80%EB%B0%94/id1368252997',
          'Web': 'https://eobuba-46c61.web.app',
          'Homepage': 'https://eobuba.co.kr',
        },
      ),
      _item(
        context,
        title: '설비 제어 및 모니터링 프로그램',
        subtitle: '2011 ~ 2022',
        readme: 'assets/projects/dtk/README.md',
        images: [
          'assets/projects/dtk/1.png',
          'assets/projects/dtk/2.png',
          'assets/projects/dtk/3.png',
          'assets/projects/dtk/4.png',
          'assets/projects/dtk/5.png',
          'assets/projects/dtk/6.png',
          'assets/projects/dtk/7.png',
          'assets/projects/dtk/8.png',
          'assets/projects/dtk/9.png',
        ],
        description: '설비 제어용 데스크탑 어플리케이션.',
        features: {
          '주요기능': '설비 모니터링 및 제어, 각종 데이터 저장',
          'Stack': 'Java, Swing, JDBC',
          'Database': 'SQLite',
          'Deployment': 'NSIS, Gradle',
        },
      ),
      _item(
        context,
        title: 'Instagram 클론코딩',
        subtitle: '2022.04 (1人 개인 프로젝트)',
        readme: 'assets/projects/instagram/README.md',
        images: [
          'assets/projects/instagram/1.jpg',
          'assets/projects/instagram/2.jpg',
          'assets/projects/instagram/3.jpg',
          'assets/projects/instagram/4.jpg',
          'assets/projects/instagram/5.jpg',
          'assets/projects/instagram/6.jpg',
          'assets/projects/instagram/7.jpg',
          'assets/projects/instagram/8.jpg',
          'assets/projects/instagram/9.jpg',
          'assets/projects/instagram/10.jpg',
          'assets/projects/instagram/11.jpg',
        ],
        description: 'Firebase 테스트 겸 제작하였습니다.\n\n'
            '모바일 환경에서 레이아웃이 최적화되었습니다.',
        features: {
          'Stack': 'Flutter, Firestore, Bloc',
          '주요기능': '게시물, 댓글, 활동, 북마크, 채팅 기능',
          'Github': 'https://github.com/chinjja/instagram',
          'Web URL': 'https://instagram-21e39.web.app',
          'Frontend': 'Web',
        },
      ),
      _item(
        context,
        title: 'V-Calendar',
        subtitle: '2022.03 (1人 개인 프로젝트)',
        readme: 'assets/projects/calendar/README.md',
        images: [
          'assets/projects/calendar/month.png',
          'assets/projects/calendar/drawer.png',
          'assets/projects/calendar/day1.png',
          'assets/projects/calendar/day2.png',
          'assets/projects/calendar/viewer.png',
          'assets/projects/calendar/editor.png',
          'assets/projects/calendar/today.png',
        ],
        description: '수직스크롤이 되는 캘린더 어플은 존재하지 않아서 제작하엿습니다.\n\n'
            '기존 데스크탑 앱들을 Flutter 기반으로 변경하고자 연습겸 만든 앱니다.',
        features: {
          '주요기능': '월간 또는 일간을 수직으로 무한 스크롤, 이벤트 생성/편집 기능',
          'Github': 'https://github.com/chinjja/flutter_calendar_app',
          'Google Play':
              'https://play.google.com/store/apps/details?id=com.chinjja.calendar',
          'Stack': 'Flutter, Provider + RxDart',
        },
      ),
      _item(
        context,
        title: 'Delayed Auditory Feedback',
        subtitle: '2018년 (1人 개인 프로젝트)',
        readme: 'assets/projects/daf/README.md',
        images: [
          'assets/projects/daf/3.png',
          'assets/projects/daf/2.png',
          'assets/projects/daf/1.png',
          'assets/projects/daf/4.png',
          'assets/projects/daf/5.png',
          'assets/projects/daf/6.png',
          'assets/projects/daf/7.png',
        ],
        description: '기존 유사 어플들은 제대로 동작이되지 않아서 직접 구글 웹사이트 보고 개발했습니다.\n\n'
            '개발하는 김에 인앱결제 및 광고도 붙여서 소소히 용돈도 벌고 있습니다.\n'
            '저지연을 달성하기 위해서 핵심 로직에 NDK를 사용했습니다.',
        features: {
          '주요기능': '정밀 가변 지연 피드백 & Low Latency',
          'Google Play':
              'https://play.google.com/store/apps/details?id=com.chinjja.app.daf',
          'Stack': 'Android, NDK',
        },
      ),
    ];

    return SliverStack(
      children: [
        SliverPositioned.fill(
          child: Container(
            color: Colors.cyan[800],
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
                  'PROJECTS',
                  color: Colors.white,
                  parent: context,
                ),
              ),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 1000,
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => slivers[index],
                    childCount: slivers.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<String> images,
    required String readme,
    required String description,
    required Map<String, String> features,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final children = [
        Flexible(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(8),
            width: 500,
            height: 440,
            child: MyImagePagenation(
              images: images,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: FilledButton.tonal(
                    onPressed: () {
                      MarkdownRoute(path: readme).push(context);
                    },
                    child: const Text('자세히 보기'),
                  ),
                ),
                const Divider(),
                Column(
                  children: features.entries
                      .map((e) => TextWithCircle(summary: e.key, text: e.value))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(subtitle),
                  ],
                ),
                const SizedBox(height: 24),
                if (constraints.maxWidth < 800)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class FullScreenPage extends StatelessWidget {
  const FullScreenPage({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);
  final List<String> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MyImagePagenation(
        images: images,
        enableTap: false,
        initialIndex: initialIndex,
      ),
    );
  }
}

class MyImagePagenation extends StatefulWidget {
  const MyImagePagenation({
    Key? key,
    required this.images,
    this.enableTap = true,
    this.initialIndex = 0,
  }) : super(key: key);
  final List<String> images;
  final int initialIndex;
  final bool enableTap;

  @override
  State<MyImagePagenation> createState() => _MyImagePagenationState();
}

class _MyImagePagenationState extends State<MyImagePagenation> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late var _currentPage = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: MouseRegion(
            cursor:
                widget.enableTap ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              onTap: widget.enableTap
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenPage(
                            images: widget.images,
                            initialIndex: _controller.page?.toInt() ?? 0,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                color: Colors.black54,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _prev,
              icon: const Icon(Icons.arrow_left),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('${_currentPage + 1}/${widget.images.length}'),
            ),
            IconButton(
              onPressed: _next,
              icon: const Icon(Icons.arrow_right),
            ),
          ],
        ),
      ],
    );
  }

  void _prev() async {
    await _controller.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  void _next() async {
    await _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }
}

class TextWithCircle extends StatelessWidget {
  const TextWithCircle({
    Key? key,
    this.lineSpacing = 2,
    this.spacing = 12,
    this.summary,
    this.summaryWidth = 100,
    required this.text,
  }) : super(key: key);
  final double lineSpacing;
  final double spacing;
  final String? summary;
  final double summaryWidth;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: lineSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              height: 24,
              child: Icon(Icons.circle, size: 6),
            ),
          ),
          SizedBox(width: spacing),
          if (summary != null)
            SizedBox(
              width: summaryWidth,
              child: Text(
                summary!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: Linkify(
              text: text,
              onOpen: (link) async {
                if (await canLaunchUrlString(link.url)) {
                  await launchUrlString(link.url);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
