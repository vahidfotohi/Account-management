import 'package:construction_manager/features/home/presentation/pages/home_page.dart';
import 'package:construction_manager/features/home/presentation/pages/transactions_page.dart';
import 'package:construction_manager/features/payments/domain/entities/payment.dart';
import 'package:construction_manager/features/payments/presentation/pages/add_payment_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/projects/domain/entities/project.dart';
import '../../features/projects/presentation/pages/add_project_page.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/receipts/presentation/pages/add_receipt_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/work_entries/presentation/pages/add_work_entry_page.dart';
import '../../features/workers/domain/entities/worker.dart';
import '../../features/workers/presentation/pages/add_worker_page.dart';
import '../../features/workers/presentation/pages/worker_details_page.dart';
import '../../features/workers/presentation/pages/workers_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // GoRoute(
      //   path: '/splash',
      //   builder: (context, state) => const VideoSplashScreen(),
      // ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'add-worker',
            builder: (context, state) => const AddWorkerPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/workers',
        builder: (context, state) => const WorkersPage(),
        routes: [
          GoRoute(
            path: 'add', // /workers/add
            builder: (context, state) => const AddWorkerPage(),
          ),
          GoRoute(
            path: 'details', // مسیر کامل: /workers/details
            builder: (context, state) {
              final worker = state.extra as Worker;
              return WorkerDetailsPage(worker: worker);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectsPage(),
        routes: [
          GoRoute(
            path: 'add', // /projects/add
            builder: (context, state) => const AddProjectPage(),
          ),
          GoRoute(
            path: 'details',
            builder: (context, state) {
              // دریافت آبجکت پروژه که پاس داده شده
              final project = state.extra as Project;
              return ProjectDetailsPage(project: project);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/add-work-entry',
        builder: (context, state) => const AddWorkEntryPage(),
      ),
      GoRoute(
        path: '/add-payment',

        builder: (context, state) {
          final payment = state.extra as Payment?;
          return AddPaymentPage(paymentToEdit: payment);
        },
      ),
      GoRoute(
        path: '/add-receipt',
        builder: (context, state) => const AddReceiptPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsPage(),
      ),
    ],
  );
}