import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/dashboard/dashboard.dart';

class DashboardForm extends ConsumerWidget {
  DashboardForm({super.key, required this.initialValue});

  final Dashboard initialValue;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard 수정'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                ref.read(dashboardsProvider.notifier).updateDashboard(
                    Dashboard.fromJson(_formKey.currentState!.value));
              } else {
                debugPrint('validation failed');
              }
              debugPrint(_formKey.currentState?.value.toString());
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: initialValue.toJson(),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'title',
              decoration: const InputDecoration(labelText: '제목'),
              validator: (value) =>
                  value == null || value.isEmpty ? '제목은 필수 입니다.' : null,
            ),
            FormBuilderTextField(
              name: 'body',
              maxLines: null,
              decoration: const InputDecoration(labelText: '내용'),
              validator: (value) =>
                  value == null || value.isEmpty ? '내용은 필수 입니다.' : null,
            ),
          ],
        ),
      ),
    );
  }
}
