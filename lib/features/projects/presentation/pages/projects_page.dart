import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../providers/projects_list_provider.dart';
import 'package:construction_manager/features/projects/domain/entities/project.dart';

class ProjectsPage extends HookConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('پروژه‌های ساختمانی'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: theme.primaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/projects/add'),
        label: const Text('پروژه جدید'),
        icon: const Icon(Icons.add_business),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return _buildEmptyState(theme);
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
            itemCount: projects.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _ProjectCard(project: projects[index]);
            },
          );
        },
        error: (e, s) => Center(child: Text('خطا: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.apartment, size: 64, color: theme.primaryColor.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          Text(
            'هیچ پروژه‌ای تعریف نشده است',
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/projects/details', extra: project),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // آیکون پروژه
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.business, color: Colors.orange.shade700),
                ),
                const SizedBox(width: 16),

                // مشخصات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              project.location ?? 'بدون آدرس',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Switch(
                      value: project.isActive,
                      activeColor: Colors.green,
                      onChanged: (val) async {
                        final updated = project.copyWith(isActive: val);
                        await ref.read(updateProjectUseCaseProvider).call(updated);
                      },
                    ),
                    Text(
                      project.isActive ? 'فعال' : 'غیرفعال',
                      style: TextStyle(fontSize: 10, color: project.isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // وضعیت
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: project.isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(
                //       color: project.isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         project.isCompleted ? Icons.check_circle : Icons.pending,
                //         size: 14,
                //         color: project.isCompleted ? Colors.green : Colors.blue,
                //       ),
                //       const SizedBox(width: 4),
                //       Text(
                //         project.isCompleted ? 'تکمیل' : 'فعال',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //           color: project.isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}