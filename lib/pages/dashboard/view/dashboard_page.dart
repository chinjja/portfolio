import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/dashboard/dashboard.dart';
import 'package:portfolio/pages/dashboard/view/dashboard_form.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = ref.watch(isOwnerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                icon: const Icon(Icons.edit)),
        ],
      ),
      body: const DashboardView(),
    );
  }
}

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardsProvider);

    return dashboard.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge,
          ),
          Text(
            data.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
