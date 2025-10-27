import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_service_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authState.isLoading
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await authController.signOut();
                    }
                  },
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '사용자 정보',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('이메일'),
                        subtitle: Text(
                          currentUser?.email ?? '없음',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('사용자 ID'),
                        subtitle: Text(
                          currentUser?.uid ?? '없음',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (currentUser?.displayName != null)
                        ListTile(
                          leading: const Icon(Icons.badge),
                          title: const Text('닉네임'),
                          subtitle: Text(
                            currentUser!.displayName!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '✅ Firebase Authentication 로그인 성공!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    await authController.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('로그아웃'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
