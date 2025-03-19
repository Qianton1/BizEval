import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizeval/providers/auth_provider.dart';
import 'package:bizeval/providers/image_provider.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageDataProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isLoggedIn;

    if (imageProvider.isAnalyzing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('分析中'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('正在分析商机，请稍候...'),
            ],
          ),
        ),
      );
    }

    final analysisResult = imageProvider.analysisResult;
    if (analysisResult == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('分析结果'),
        ),
        body: const Center(
          child: Text('暂无分析结果，请先拍照或上传照片'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('分析结果'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图像预览（实际应用中会显示真实图片）
            // 图像预览
            imageProvider.selectedImage != null
                ? Container(
              width: double.infinity,
              height: 200,
              child: Image.file(
                imageProvider.selectedImage!,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 图像质量
            Row(
              children: [
                const Icon(Icons.photo_camera, color: Colors.grey),
                const SizedBox(width: 8),
                Text('图像质量: ${analysisResult.imageQuality}'),
              ],
            ),

            const SizedBox(height: 20),

            // 分析摘要
            const Text(
              '分析摘要',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(analysisResult.summary),

            const SizedBox(height: 20),

            // 商机列表
            const Text(
              '发现的商机',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...analysisResult.opportunities.map((opportunity) {
              if (opportunity.isPremium && !isLoggedIn) {
                // 未登录用户看到的高级内容
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${opportunity.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    opportunity.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.lock,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '登录后查看完整内容',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // 所有用户都能看到的内容，或已登录用户看到的高级内容
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${opportunity.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opportunity.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(opportunity.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }).toList(),

            const SizedBox(height: 30),

            // 登录提示（如果用户未登录且有高级内容）
            if (!isLoggedIn && analysisResult.opportunities.any((o) => o.isPremium))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      '登录后查看完整分析报告',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('立即登录'),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 底部按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('返回首页'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 返回拍照页面
                      Navigator.pushReplacementNamed(context, '/camera');
                    },
                    child: const Text('重新拍摄'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}