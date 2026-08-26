import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class PdfDownloadsPage extends StatelessWidget {
  const PdfDownloadsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> pdfCategories = const [
    {
      'title': 'Alphabets',
      'icon': '🔤',
      'color': Color(0xFFFF6B6B),
      'pdfs': [
        {'name': 'Capital Letters A-Z', 'pages': 26},
        {'name': 'Small Letters a-z', 'pages': 26},
        {'name': 'Letter Tracing Worksheets', 'pages': 52},
      ],
    },
    {
      'title': 'Numbers',
      'icon': '🔢',
      'color': Color(0xFF4ECDC4),
      'pdfs': [
        {'name': 'Numbers', 'pages': 20},
        {'name': 'Number Tracing 1-20', 'pages': 20},
        {'name': 'Counting Worksheets', 'pages': 15},
      ],
    },
    {
      'title': 'Math Tables',
      'icon': '✖️',
      'color': Color(0xFFFFAA5A),
      'pdfs': [
        {'name': 'Tables 2-10', 'pages': 9},
        {'name': 'Tables 11-20', 'pages': 10},
        {'name': 'Math Practice Sheets', 'pages': 25},
      ],
    },
    {
      'title': 'Hindi',
      'icon': '🇮🇳',
      'color': Color(0xFFA78BFA),
      'pdfs': [
        {'name': 'Hindi Swar (स्वर)', 'pages': 13},
        {'name': 'Hindi Vyanjan (व्यंजन)', 'pages': 36},
        {'name': 'Hindi Words', 'pages': 20},
      ],
    },
    {
      'title': 'Learning Sets',
      'icon': '📚',
      'color': Color(0xFF56D97F),
      'pdfs': [
        {'name': 'Animals Names', 'pages': 15},
        {'name': 'Birds Names', 'pages': 12},
        {'name': 'Fruits & Vegetables', 'pages': 20},
        {'name': 'Colors & Shapes', 'pages': 10},
        {'name': 'Body Parts', 'pages': 8},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "PDF Downloads",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: pdfCategories.length,
          itemBuilder: (context, index) {
            final category = pdfCategories[index];
            return _buildCategoryCard(category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final color = category['color'] as Color;
    final pdfs = category['pdfs'] as List<Map<String, dynamic>>;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          childrenPadding: EdgeInsets.only(bottom: 16.h),
          leading: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                category['icon'],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          title: Text(
            category['title'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          subtitle: Text(
            '${pdfs.length} PDFs available',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          children: pdfs.map((pdf) => _buildPdfItem(pdf, color)).toList(),
        ),
      ),
    );
  }

  Widget _buildPdfItem(Map<String, dynamic> pdf, Color color) {
    final RxBool isDownloading = false.obs;
    final RxBool isDownloaded = false.obs;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pdf['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${pdf['pages']} pages',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (isDownloading.value) {
                return SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                );
              }
              if (isDownloaded.value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility, color: color),
                      onPressed: () => _viewPdf(pdf['name']),
                      tooltip: 'View',
                    ),
                    Icon(Icons.check_circle, color: Colors.green, size: 24.r),
                  ],
                );
              }
              return IconButton(
                icon: Icon(Icons.download, color: color),
                onPressed: () async {
                  isDownloading.value = true;
                  await Future.delayed(const Duration(seconds: 2));
                  isDownloading.value = false;
                  isDownloaded.value = true;
                  Get.snackbar(
                    'Downloaded!',
                    '${pdf['name']} has been downloaded.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _viewPdf(String pdfName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_as_pdf, size: 60.r, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                pdfName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description,
                        size: 50.r,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'PDF Preview',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Sharing...',
                          'Opening share dialog for $pdfName',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
