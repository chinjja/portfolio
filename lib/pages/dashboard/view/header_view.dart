import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/pages/pages.dart';

class Header extends HookConsumerWidget {
  const Header({Key? key, this.linkKey}) : super(key: key);
  final GlobalKey? linkKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardsProvider).valueOrNull;
    final padding = MediaQuery.of(context).padding;
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 500 + padding.top,
            child: Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
              scale: 2,
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 50,
            child: Column(
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        dashboard?.title ?? '',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Container(
                      height: 4,
                      decoration: ShapeDecoration(
                        color: Colors.orange[800],
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      dashboard?.body ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 1.3,
                        color: Colors.white,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 5,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-1, -1),
                            blurRadius: 5,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: Material(
                    elevation: 4,
                    shape: const StadiumBorder(),
                    color: Colors.orange[800],
                    child: InkWell(
                      onTap: linkKey == null
                          ? null
                          : () {
                              Scrollable.ensureVisible(
                                linkKey!.currentContext!,
                                duration: const Duration(milliseconds: 250),
                              );
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '더 알아보기',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
