import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/masonry/masonry.dart';
import 'package:portfolio/widgets/widgets.dart';

class SkillsView extends HookConsumerWidget {
  const SkillsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(
          vertical: 60,
        ),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: Column(
              children: [
                LinkTitle(
                  'SKILLS',
                  parent: context,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Masonry(
                    horizontalExtent: 250,
                    horizontalSpacing: 32,
                    verticalSpacing: 16,
                    children: [
                      _skill(title: 'Mobile App', children: [
                        _flutterLogo(),
                        _androidLogo(),
                        _javaLogo(),
                      ]),
                      _skill(title: 'Desktop App', children: [
                        _javaLogo(),
                      ]),
                      _skill(title: 'Backend', children: [
                        _springLogo(),
                        _javaLogo(),
                      ]),
                      _skill(title: 'FrontEnd', children: [
                        _flutterLogo(),
                      ]),
                      _skill(title: 'Database', children: [
                        _sqliteLogo(),
                        _mariadbLogo(),
                      ]),
                      _skill(title: 'Version Control', children: [
                        _gitLogo(),
                        _githubLogo(),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _springLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/logos/spring.png',
          height: 70,
        ),
        const SizedBox(width: 8),
        const Text(
          'Spring\nBoot',
          style: TextStyle(fontSize: 26),
        )
      ],
    );
  }

  Widget _flutterLogo() {
    return const Row(
      children: [
        FlutterLogo(size: 70),
        Text(
          'Flutter',
          style: TextStyle(fontSize: 30),
        )
      ],
    );
  }

  Widget _androidLogo() {
    return Image.asset(
      'assets/logos/android.png',
      width: double.infinity,
      height: 70,
      fit: BoxFit.cover,
    );
  }

  Widget _sqliteLogo() {
    return Image.asset(
      'assets/logos/sqlite.png',
      width: double.infinity,
      height: 70,
      fit: BoxFit.cover,
    );
  }

  Widget _mariadbLogo() {
    return Image.asset(
      'assets/logos/mariadb.png',
      width: double.infinity,
      height: 70,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _javaLogo() {
    return Image.asset(
      'assets/logos/java.png',
      width: 160,
      height: 70,
      fit: BoxFit.cover,
    );
  }

  Widget _gitLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/logos/git.png',
          height: 70,
        ),
        const SizedBox(width: 8),
        const Text(
          'Git',
          style: TextStyle(fontSize: 30),
        )
      ],
    );
  }

  Widget _githubLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/logos/github.png',
          height: 70,
        ),
        const SizedBox(width: 8),
        const Text(
          'GitHub',
          style: TextStyle(fontSize: 30),
        )
      ],
    );
  }

  Widget _skill({required String title, required List<Widget> children}) {
    return Center(
      child: Card(
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide()),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: children
                    .map(
                      (e) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: e,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
