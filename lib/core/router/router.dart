import 'package:construction_manager/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/projects/presentation/pages/add_project_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/work_entries/presentation/pages/add_work_entry_page.dart';
import '../../features/workers/presentation/pages/add_worker_page.dart';
import '../../features/workers/presentation/pages/workers_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
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
        ],
      ),
      GoRoute(
        path: '/add-work-entry',
        builder: (context, state) => const AddWorkEntryPage(),
      ),
    ],
  );
}