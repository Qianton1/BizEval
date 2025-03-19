import 'dart:io';
import 'package:flutter/material.dart';

class BusinessOpportunity {
  final int id;
  final String title;
  final String description;
  final Offset position; // 在图像上的位置
  final bool isPremium; // 是否为高级内容（需要登录查看）

  BusinessOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    this.isPremium = false,
  });
}

class AnalysisResult {
  final String imageQuality; // 图像质量评价
  final List<BusinessOpportunity> opportunities; // 商机点列表
  final String summary; // 总结

  AnalysisResult({
    required this.imageQuality,
    required this.opportunities,
    required this.summary,
  });
}

class ImageDataProvider extends ChangeNotifier {
  File? _selectedImage;
  bool _isAnalyzing = false;
  AnalysisResult? _analysisResult;

  File? get selectedImage => _selectedImage;
  bool get isAnalyzing => _isAnalyzing;
  AnalysisResult? get analysisResult => _analysisResult;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    _analysisResult = null;
    notifyListeners();
  }

  void clearImage() {
    _selectedImage = null;
    _analysisResult = null;
    notifyListeners();
  }

  Future<void> analyzeImage() async {
    if (_selectedImage == null) {
      // 即使没有真实图片，也允许模拟分析
      _isAnalyzing = true;
      notifyListeners();

      // 模拟分析过程
      await Future.delayed(const Duration(seconds: 2));

      // 创建模拟的分析结果
      _analysisResult = AnalysisResult(
        imageQuality: "良好",
        summary: "该场景包含多个潜在商机，建议关注客流量和店面布局优化。",
        opportunities: [
          BusinessOpportunity(
            id: 1,
            title: "客流量分析",
            description: "根据图像中的人流密度，该区域客流量适中，有增长潜力。",
            position: const Offset(0.3, 0.4),
            isPremium: false,
          ),
          BusinessOpportunity(
            id: 2,
            title: "店面布局",
            description: "店面布局可优化，建议调整货架位置以提高顾客停留时间。",
            position: const Offset(0.6, 0.3),
            isPremium: false,
          ),
          BusinessOpportunity(
            id: 3,
            title: "竞争分析",
            description: "周边竞争情况分析及差异化经营策略建议。",
            position: const Offset(0.7, 0.7),
            isPremium: true,
          ),
        ],
      );

      _isAnalyzing = false;
      notifyListeners();
    }
  }
}