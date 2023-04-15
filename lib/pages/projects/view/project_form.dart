import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';

class ProjectForm extends HookConsumerWidget {
  ProjectForm({super.key, this.initialValue});

  final _formKey = GlobalKey<FormBuilderState>();
  final Project? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = submitProjectProvider(initialValue);
    ref.listen(
      provider,
      (previous, next) {
        next.whenOrNull(
          data: (data) {
            context.pop();
          },
          error: (error, stackTrace) {
            context.showSnackbarOk(error.toString());
          },
        );
      },
    );
    final loading = ref.watch(provider).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: initialValue == null
            ? const Text('프로젝트 추가')
            : const Text('프로젝트 수정'),
        actions: [
          IconButton(
            onPressed: loading
                ? null
                : () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      ref.read(provider.notifier).submit(
                          Project.fromJson(_formKey.currentState!.value));
                    }
                  },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: (initialValue ?? const Project()).toJson(),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'title',
              decoration: const InputDecoration(labelText: '제목'),
            ),
            FormBuilderTextField(
              name: 'subtitle',
              decoration: const InputDecoration(labelText: '서브제목'),
            ),
            FormBuilderTextField(
              name: 'body',
              decoration: const InputDecoration(labelText: '바디'),
            ),
            FormBuilderTextField(
              name: 'summary',
              decoration: const InputDecoration(labelText: '요약'),
            ),
          ],
        ),
      ),
    );
  }
}
