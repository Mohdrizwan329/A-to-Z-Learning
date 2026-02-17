import 'package:get/get.dart';

class TermsConditionsController extends GetxController {
  final title = 'Terms & Conditions'.obs;
  final subTitle =
      'Welcome to Learning For Kids! By using our educational app, you agree to these terms. Parents/guardians must read and accept these terms on behalf of their children.'
          .obs;

  final sections = <Map<String, dynamic>>[
    {
      'title': '1. Age Requirements',
      'bullets': [
        'This app is designed for children ages 3-12 years.',
        'Children must use the app under parental supervision.',
        'Parents/guardians are responsible for their child\'s use of the app.',
      ],
    },
    {
      'title': '2. Educational Content',
      'bullets': [
        'All content is designed for educational purposes only.',
        'We strive to provide accurate and age-appropriate learning materials.',
        'Content includes: Numbers, Alphabets, Hindi Letters, Math, Drawing, and more.',
      ],
    },
    {
      'title': '3. User Account',
      'bullets': [
        'Parents can create accounts for their children.',
        'Keep login credentials secure and private.',
        'One account per child is recommended for personalized learning.',
      ],
    },
    {
      'title': '4. Subscription & Payments',
      'bullets': [
        'Basic features are available for free.',
        'Premium features require subscription.',
        'Parents must authorize all purchases.',
        'Refund requests are handled as per our refund policy.',
      ],
    },
    {
      'title': '5. Child Safety',
      'bullets': [
        'We do not allow direct communication between users.',
        'No personal information sharing features are available.',
        'All content is reviewed for child safety compliance.',
      ],
    },
    {
      'title': '6. Acceptable Use',
      'bullets': [
        'Use the app only for learning and educational purposes.',
        'Do not attempt to modify or hack the app.',
        'Report any bugs or issues through the Help section.',
      ],
    },
    {
      'title': '7. Intellectual Property',
      'bullets': [
        'All content, designs, and materials are owned by Learning For Kids.',
        'Users may not copy, distribute, or modify app content.',
        'Educational materials are for personal use only.',
      ],
    },
    {
      'title': '8. Updates & Changes',
      'bullets': [
        'We regularly update content to improve learning experience.',
        'App features may change with updates.',
        'We will notify users of significant changes.',
      ],
    },
    {
      'title': '9. Limitation of Liability',
      'bullets': [
        'The app is provided "as is" for educational purposes.',
        'We are not liable for learning outcomes or results.',
        'Technical issues will be resolved as quickly as possible.',
      ],
    },
    {
      'title': '10. Contact Us',
      'bullets': [
        'For questions about these terms, contact us through the app.',
        'Email: support@learningforkids.com',
        'We respond to all queries within 48 hours.',
      ],
    },
  ].obs;
}
