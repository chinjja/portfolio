import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AboutMeView extends HookConsumerWidget {
  const AboutMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: LinkTitle(
              'ABOUT ME',
              parent: context,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 48,
              right: 48,
              bottom: 32,
            ),
            sliver: SliverCrossAxisConstrained(
              maxCrossAxisExtent: 900,
              child: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 50,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate.fixed(
                  [
                    _item(Icons.person, '이름', '박정현'),
                    _item(Icons.today, '생년월일', '87.4.1'),
                    _item(Icons.person, '주소지', '경남 창원시'),
                    _item(Icons.phone, '연락처', '010-2882-7458'),
                    _item(Icons.email, '이메일', 'chinjja@gmail.com'),
                    _item(Icons.person, '학력', '구미전자공고 (고졸)'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, String subtitle) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 32),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
