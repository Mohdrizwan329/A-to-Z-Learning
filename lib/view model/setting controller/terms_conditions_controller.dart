import 'package:get/get.dart';

class TermsConditionsController extends GetxController {
  final title = 'Terms & condition'.obs;
  final subTitle =
      'Welcome to Sheegravivaham Matrimony. By accessing or using our platform, you agree to comply with and be bound by the following terms and conditions. Please read them carefully before using our services.'
          .obs;

  final sections = <Map<String, dynamic>>[
    {
      'title': '1. Eligibility',
      'bullets': [
        'You must be at least 18 years old (for women) and 21 years old (for men) to register.',
        'You must provide accurate and truthful personal details.',
        'You must not have a prior criminal record or history of fraudulent activities.',
      ],
    },
    {
      'title': '2. Account Registration & Security',
      'bullets': [
        'You are responsible for maintaining the confidentiality of your account credentials.',
        'Any unauthorized use of your account should be reported immediately.',
        'Sheegravivaham Matrimony reserves the right to verify the authenticity of profiles and remove any suspicious accounts.',
      ],
    },
    {
      'title': '3. User Responsibilities',
      'bullets': [
        'You agree to use this platform only for lawful matrimonial purposes.',
        'You must not post false, misleading, offensive, or illegal content.',
        'Harassment, abusive behavior, or sharing of explicit content is strictly prohibited.',
      ],
    },
    {
      'title': '4. Profile Verification & Approval',
      'bullets': [
        'All profiles undergo a verification process to ensure authenticity.',
        'We reserve the right to accept or reject any profile at our discretion.',
        'Any misrepresentation in your profile may lead to suspension or termination.',
      ],
    },
    {
      'title': '5. Membership & Payments',
      'bullets': [
        'Some features of the platform may require paid membership.',
        'Payments once made are non-refundable, except in cases where the service is not provided as promised.',
        'Membership benefits and pricing may change at any time with prior notification.',
      ],
    },
    {
      'title': '6. Privacy & Data Protection',
      'bullets': [
        'Your personal data is protected under our Privacy Policy.',
        'We do not share your information with third parties without your consent.',
        'However. Sheegravivaham Matrimony is not responsible for any misuse of data by third parties.',
      ],
    },
    {
      'title': '7. Communication & Matchmaking',
      'bullets': [
        'Sheegravivaham Matrimony only acts as a platform to connect individuals.',
        'We do not guarantee marriage or relationship success.',
        'Users are advised to exercise caution while interacting with other members.',
      ],
    },
    {
      'title': '8. Prohibited Activities',
      'bullets': [
        'Users are strictly prohibited from:',
        'Creating fake profiles or impersonating someone else.',
        'Asking for or engaging in financial transactions.',
        'Sharing obscene, abusive, or offensive content.',
        'Using the platform for commercial, promotional, or business purposes.',
      ],
    },
    {
      'title': '9. Termination of Account',
      'bullets': [
        'We reserve the right to terminate or suspend accounts that violate these terms.',
        'A user can voluntarily delete their account at any time.',
        'Termination due to policy violajin does not warrant any refund.',
      ],
    },
    {
      'title': '10. Limitation of Liability',
      'bullets': [
        'Sheegravivaham Matrimony is not liable for any financial, emotional, or legal consequences arising from matches made on the platform.',
        'We do not verify every users background and recommend due diligence before proceeding with marriage discussions.',
      ],
    },
    {
      'title': '11. Changes to Terms & Conditions',
      'bullets': [
        'We may update these terms from time to time, and continued use of the platform implies acceptance of any modifications.',
      ],
    },
    {
      'title': '12. Governing Law & Dispute Resolution',
      'bullets': [
        'These terms are governed by the laws of India.',
        'Any disputes will be resolved through arbitration or courts located in [City/State].',
      ],
    },
    {
      'title': '13. Contact Information',
      'bullets': [
        'For any questions or concerns regarding these Terms & Conditions, you can contact us at:',
        'Email: [support@sheegravivaham.com]',
      ],
    },
  ].obs;
}
