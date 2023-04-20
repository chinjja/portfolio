import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Career extends HookConsumerWidget {
  const Career({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverStack(
      children: [
        SliverPositioned.fill(
          child: Container(
            color: Colors.grey[200],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 60,
          ),
          sliver: MultiSliver(
            children: [
              SliverToBoxAdapter(
                child: LinkTitle(
                  'CAREER',
                  parent: context,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    _thecompany(),
                    const Divider(height: 32),
                    _dtk(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thecompany() {
    return Center(
      child: SizedBox(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '(주) 더컴퍼니',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '2022.12 ~ 현재',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            const Text('AI 및 서비스 플랫폼 소프트웨어 회사입니다.'),
            const SizedBox(height: 16),
            const Text(
                '서비스 플랫폼 전적으로 담당하였고, 기존 [어부바]라는 앱이 문제점이 많아 첨부터 다시 개발하였습니다.'),
            const SizedBox(height: 16),
            _block(
              title: '어부바 앱 리뉴얼',
              subtitle: '2023년 2월 ~ 2023년 4월 (2개월)',
              texts: [
                '안드로이드 & iOS 앱 백지에서 다시 리뉴얼',
                '백엔드 서버 백지에서 다시 리뉴얼',
                '프로젝트 탭에 상세한 정보가 있습니다.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dtk() {
    return Center(
      child: SizedBox(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '(주) 대호테크',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '2006 ~ 2022.12',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            const Text('자동화 설비 전문 기업입니다. 주력 설비는 열성형 설비입니다.'),
            const SizedBox(height: 16),
            const Text(
                '기본적으로는 Java를 이용하여 프로그램적으로 필요한 모든 부분(통신, UI, DB, 각종 고객 커스텀 기능)을 총괄 담당하고 있으며, 원격제어 및 통합관리를 위해서 Flutter 및 스프링을 도입할 목적으로 시간 나는대로 여러 토이 프로젝트를 진행하고 있습니다.'),
            const SizedBox(height: 16),
            _block(
              title: '설비 제어 제작 및 설계',
              subtitle: '2006년 ~ 2011년',
              texts: [
                '전기회로 설계 및 제작',
                'PLC 프로그램 개발',
              ],
            ),
            _block(
              title: '프로그램 관련 모든 부분 담당',
              subtitle: '2012년 ~ 2022년',
              texts: [
                'Java Swing 기반으로 UI 개발',
                '각종 디바이스 통신 및 네트워크 통신 개발',
                '레시피 및 트렌드 데이터에 관계 DB 도입',
                'NSIS와 Gradle, Git 도입하여 자동 버저닝이 반영된 인스톨러 생성 도입',
                '라이프사이클 개념 도입',
                '활성/비활성 조건 Tree 구조기반 UI 상태 눈관리 및 반응 도입',
                'Windows Service 마이크로 서비스를 개발하여 사용기간을 제한하는 기능 도입',
                '각종 사내 유틸리티 프로그램 개발',
                '각종 고객 커스텀 기능 개발',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _block({
    required String title,
    required String subtitle,
    required List<String> texts,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ...texts
              .map(
                (e) => Text(e),
              )
              .toList()
        ],
      ),
    );
  }
}
