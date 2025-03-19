import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bizeval/providers/image_provider.dart';

class UploadPlaceholder extends StatefulWidget {
  const UploadPlaceholder({Key? key}) : super(key: key);

  @override
  State<UploadPlaceholder> createState() => _UploadPlaceholderState();
}

class _UploadPlaceholderState extends State<UploadPlaceholder> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片时出错: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    final imageProvider = Provider.of<ImageDataProvider>(context, listen: false);
    imageProvider.setSelectedImage(_selectedImage);
    imageProvider.analyzeImage();
    Navigator.pushReplacementNamed(context, '/analysis');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上传照片'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _selectedImage != null
                  ? Image.file(
                _selectedImage!,
                fit: BoxFit.contain,
              )
                  : GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 80,
                        color: Colors.blue[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '点击选择照片',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '支持 JPG、PNG 格式',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null) ...[
              ElevatedButton(
                onPressed: _analyzeImage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('开始分析'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('重新选择'),
              ),
            ] else
              ElevatedButton(
                onPressed: _isLoading ? null : _pickImage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('从相册选择'),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/camera');
              },
              child: const Text('使用相机拍摄'),
            ),
          ],
        ),
      ),
    );
  }
}