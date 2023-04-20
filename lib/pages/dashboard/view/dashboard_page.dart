import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/pages/dashboard/view/dashboard_form.dart';
import 'package:portfolio/pages/pages.dart';

class DashboardPage extends HookConsumerWidget {
  DashboardPage({super.key});

  final _header = GlobalKey();
  final _aboutMe = GlobalKey();
  final _skills = GlobalKey();
  final _archiving = GlobalKey();
  final _career = GlobalKey();

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
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: InkWell(
              child: const Text("PJH's Portfolio👋"),
              onTap: () {
                _scrollTo(_header);
              },
            ),
            actions: [
              if (isOwner)
                IconButton(
                  onPressed: () {
                    final dashboard = ref.read(dashboardsProvider).requireValue;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardForm(initialValue: dashboard),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              _MyLinkButton('About me', linkKey: _aboutMe),
              _MyLinkButton('Skills', linkKey: _skills),
              _MyLinkButton('Archiving', linkKey: _archiving),
              _MyLinkButton('Career', linkKey: _career),
            ],
          ),
          Header(key: _header, linkKey: _aboutMe),
          AboutMeView(key: _aboutMe),
          SkillsView(key: _skills),
          ArchivingView(key: _archiving),
          Career(key: _career),
        ],
      ),
      floatingActionButton: floatingShow.value
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollTo(_header);
              },
            )
          : null,
    );
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 250),
    );
  }
}

class _MyLinkButton extends StatelessWidget {
  const _MyLinkButton(
    this.title, {
    Key? key,
    required this.linkKey,
  }) : super(key: key);
  final String title;
  final GlobalKey linkKey;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
      ),
      onPressed: () {
        Scrollable.ensureVisible(
          linkKey.currentContext!,
          duration: const Duration(milliseconds: 250),
        );
      },
    );
  }
}
