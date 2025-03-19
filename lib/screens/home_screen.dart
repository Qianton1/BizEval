import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizeval/providers/auth_provider.dart';
import 'package:bizeval/widgets/app_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BizEval 商机评估'),
        actions: [
          IconButton(
            icon: Icon(
              authProvider.isLoggedIn ? Icons.account_circle : Icons.login,
            ),
            onPressed: () {
              if (authProvider.isLoggedIn) {
                // 显示用户信息或登出选项
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('用户信息'),
                    content: Text('手机号: ${authProvider.phoneNumber}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pop(context);
                        },
                        child: const Text('退出登录'),
                      ),
                    ],
                  ),
                );
              } else {
                // 导航到登录页面
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 100),
            const SizedBox(height: 20),
            const Text(
              '商机评估助手',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '拍照或上传图片，智能分析商业机会',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.camera_alt,
                  label: '拍照',
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera');
                  },
                ),
                const SizedBox(width: 30),
                _buildActionButton(
                  context,
                  icon: Icons.photo_library,
                  label: '上传照片',
                  onPressed: () {
                    Navigator.pushNamed(context, '/upload');
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            if (!authProvider.isLoggedIn)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('登录查看完整报告'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
      }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            minimumSize: const Size(120, 120),
          ),
          child: Icon(
            icon,
            size: 50,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}