import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

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
                blurRadius: 10,
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
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pdfCategories.length,
          itemBuilder: (context, index) {
            final category = pdfCategories[index];
            return _buildCategoryCard(category);
          },
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final color = category['color'] as Color;
    final pdfs = category['pdfs'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
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
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
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
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                pdfName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PDF Preview',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
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
