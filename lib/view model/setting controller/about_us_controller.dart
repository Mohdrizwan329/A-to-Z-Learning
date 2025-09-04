import 'package:get/get.dart';

class AboutUsController extends GetxController {
  final title = 'About us'.obs;
  final subTitle =
      'Sheegravivaham Matrimony is a dedicated matchmaking platform committed to helping individuals find their life partners. We focus on compatibility, shared values, and secure connections to make the matchmaking process seamless. Our mission is to simplify and enhance matrimonial searches with advanced technology and user-friendly features. We prioritize security, privacy, and user satisfaction to create a trustworthy platform for meaningful relationships.'
          .obs;

  final sections = <Map<String, dynamic>>[
    {
      'title': '1. Information We Collect',
      'bullets': [
        'We collect personal details such as name, age, gender, email, phone number, photographs, and profile preferences to facilitate matchmaking.',
      ],
    },

    {
      'title': '2. How We Use Your Information',
      'bullets': [
        'Your data is used to create and manage profiles, enable communication, improve services, and ensure security.',
      ],
    },
    {
      'title': '3. Data Security',
      'bullets': [
        'We implement security measures to protect your information from unauthorized access and misuse.',
      ],
    },
    {
      'title': '4. Your Rights',
      'bullets': [
        'You can access, update, or delete your profile information and opt out of marketing communications at any time.',
      ],
    },
    {
      'title': '5. Updates to This Policy',
      'bullets': [
        'We may update this policy, and any changes will be communicated through our app.',
      ],
    },
  ].obs;
}
