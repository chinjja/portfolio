import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';

class ProjectPage extends HookConsumerWidget {
  final String id;

  const ProjectPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(getProjectProvider(id)).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(project?.title ?? ''),
        actions: [
          if (project != null) _Delete(project),
          IconButton(
            onPressed: () {
              context.go('/projects/edit', extra: project!);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ProjectView(id: id),
    );
  }
}

class ProjectView extends HookConsumerWidget {
  final String id;

  const ProjectView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(getProjectProvider(id));
    return project.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => data == null
          ? const Text('Not exists')
          : Column(
              children: [
                Text(data.title),
                Text(data.subtitle),
                Text(data.body),
                Text(data.summary),
              ],
            ),
    );
  }
}

class _Delete extends HookConsumerWidget {
  final Project project;

  const _Delete(this.project);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = deleteProjectProvider(project);
    ref.listen(provider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          context.pop();
        },
        error: (error, stackTrace) {
          context.showSnackbarOk(error.toString());
        },
      );
    });
    final loading = ref.watch(provider).isLoading;
    return IconButton(
      onPressed: loading
          ? null
          : () {
              ref.read(provider.notifier).delete();
            },
      icon: const Icon(Icons.delete),
    );
  }
}
