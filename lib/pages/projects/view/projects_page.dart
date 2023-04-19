import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';

class ProjectsPage extends HookConsumerWidget {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = ref.watch(isOwnerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로젝트'),
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
      body: const ProjectsView(),
    );
  }
}

class ProjectsView extends HookConsumerWidget {
  const ProjectsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(getProjectsProvider);
    return projects.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) => ProjectTile(
          key: ValueKey(data[index].id),
          project: data[index],
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class ProjectTile extends HookConsumerWidget {
  final Project project;

  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(project.title),
      subtitle: Text(project.subtitle),
      onTap: () {
        context.go('/projects/${project.id}');
      },
    );
  }
}
