import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class MoneyConceptsPage extends StatefulWidget {
  const MoneyConceptsPage({super.key});

  @override
  State<MoneyConceptsPage> createState() => _MoneyConceptsPageState();
}

class _MoneyConceptsPageState extends State<MoneyConceptsPage>
    with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;
  int score = 0;

  // Animation controllers
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;

  // Card gradient colors
  final List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
    [Color(0xFF4ECDC4), Color(0xFF2ECC71)],
    [Color(0xFFA855F7), Color(0xFF6366F1)],
    [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFFF093FB), Color(0xFFF5576C)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    [Color(0xFFFA709A), Color(0xFFFEE140)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFFFF0844), Color(0xFFFFB199)],
  ];

  // All Countries Currency Data
  final List<Map<String, dynamic>> allCountriesCurrency = [
    // India
    {
      'country': 'India',
      'flag': '🇮🇳',
      'currency': 'Rupee',
      'symbol': '₹',
      'code': 'INR',
      'coins': [
        {'value': '₹1', 'name': '1 Rupee'},
        {'value': '₹2', 'name': '2 Rupees'},
        {'value': '₹5', 'name': '5 Rupees'},
        {'value': '₹10', 'name': '10 Rupees'},
      ],
      'notes': [
        {'value': '₹10', 'name': 'Ten Rupees', 'color': Color(0xFFFF9933)},
        {'value': '₹20', 'name': 'Twenty Rupees', 'color': Color(0xFF00FF7F)},
        {'value': '₹50', 'name': 'Fifty Rupees', 'color': Color(0xFF00BFFF)},
        {'value': '₹100', 'name': 'Hundred Rupees', 'color': Color(0xFF9370DB)},
        {
          'value': '₹200',
          'name': 'Two Hundred Rupees',
          'color': Color(0xFFFF69B4),
        },
        {
          'value': '₹500',
          'name': 'Five Hundred Rupees',
          'color': Color(0xFF8B4513),
        },
        {
          'value': '₹2000',
          'name': 'Two Thousand Rupees',
          'color': Color(0xFFE91E63),
        },
      ],
      'color': Color(0xFFFF9933),
    },
    // USA
    {
      'country': 'United States',
      'flag': '🇺🇸',
      'currency': 'Dollar',
      'symbol': '\$',
      'code': 'USD',
      'coins': [
        {'value': '1¢', 'name': 'Penny'},
        {'value': '5¢', 'name': 'Nickel'},
        {'value': '10¢', 'name': 'Dime'},
        {'value': '25¢', 'name': 'Quarter'},
        {'value': '50¢', 'name': 'Half Dollar'},
        {'value': '\$1', 'name': 'Dollar Coin'},
      ],
      'notes': [
        {'value': '\$1', 'name': 'One Dollar', 'color': Color(0xFF85BB65)},
        {'value': '\$5', 'name': 'Five Dollars', 'color': Color(0xFF85BB65)},
        {'value': '\$10', 'name': 'Ten Dollars', 'color': Color(0xFF85BB65)},
        {'value': '\$20', 'name': 'Twenty Dollars', 'color': Color(0xFF85BB65)},
        {'value': '\$50', 'name': 'Fifty Dollars', 'color': Color(0xFF85BB65)},
        {
          'value': '\$100',
          'name': 'Hundred Dollars',
          'color': Color(0xFF85BB65),
        },
      ],
      'color': Color(0xFF3C3B6E),
    },
    // United Kingdom
    {
      'country': 'United Kingdom',
      'flag': '🇬🇧',
      'currency': 'Pound',
      'symbol': '£',
      'code': 'GBP',
      'coins': [
        {'value': '1p', 'name': 'One Penny'},
        {'value': '2p', 'name': 'Two Pence'},
        {'value': '5p', 'name': 'Five Pence'},
        {'value': '10p', 'name': 'Ten Pence'},
        {'value': '20p', 'name': 'Twenty Pence'},
        {'value': '50p', 'name': 'Fifty Pence'},
        {'value': '£1', 'name': 'One Pound'},
        {'value': '£2', 'name': 'Two Pounds'},
      ],
      'notes': [
        {'value': '£5', 'name': 'Five Pounds', 'color': Color(0xFF00CED1)},
        {'value': '£10', 'name': 'Ten Pounds', 'color': Color(0xFFFF8C00)},
        {'value': '£20', 'name': 'Twenty Pounds', 'color': Color(0xFF9370DB)},
        {'value': '£50', 'name': 'Fifty Pounds', 'color': Color(0xFFDC143C)},
      ],
      'color': Color(0xFF012169),
    },
    // European Union
    {
      'country': 'European Union',
      'flag': '🇪🇺',
      'currency': 'Euro',
      'symbol': '€',
      'code': 'EUR',
      'coins': [
        {'value': '1c', 'name': 'One Cent'},
        {'value': '2c', 'name': 'Two Cents'},
        {'value': '5c', 'name': 'Five Cents'},
        {'value': '10c', 'name': 'Ten Cents'},
        {'value': '20c', 'name': 'Twenty Cents'},
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': '€1', 'name': 'One Euro'},
        {'value': '€2', 'name': 'Two Euros'},
      ],
      'notes': [
        {'value': '€5', 'name': 'Five Euros', 'color': Color(0xFF808080)},
        {'value': '€10', 'name': 'Ten Euros', 'color': Color(0xFFFF6347)},
        {'value': '€20', 'name': 'Twenty Euros', 'color': Color(0xFF4169E1)},
        {'value': '€50', 'name': 'Fifty Euros', 'color': Color(0xFFFFA500)},
        {'value': '€100', 'name': 'Hundred Euros', 'color': Color(0xFF32CD32)},
        {
          'value': '€200',
          'name': 'Two Hundred Euros',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '€500',
          'name': 'Five Hundred Euros',
          'color': Color(0xFF9932CC),
        },
      ],
      'color': Color(0xFF003399),
    },
    // Japan
    {
      'country': 'Japan',
      'flag': '🇯🇵',
      'currency': 'Yen',
      'symbol': '¥',
      'code': 'JPY',
      'coins': [
        {'value': '¥1', 'name': 'One Yen'},
        {'value': '¥5', 'name': 'Five Yen'},
        {'value': '¥10', 'name': 'Ten Yen'},
        {'value': '¥50', 'name': 'Fifty Yen'},
        {'value': '¥100', 'name': 'Hundred Yen'},
        {'value': '¥500', 'name': 'Five Hundred Yen'},
      ],
      'notes': [
        {
          'value': '¥1000',
          'name': 'One Thousand Yen',
          'color': Color(0xFF4169E1),
        },
        {
          'value': '¥5000',
          'name': 'Five Thousand Yen',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '¥10000',
          'name': 'Ten Thousand Yen',
          'color': Color(0xFFD4A574),
        },
      ],
      'color': Color(0xFFBC002D),
    },
    // China
    {
      'country': 'China',
      'flag': '🇨🇳',
      'currency': 'Yuan',
      'symbol': '¥',
      'code': 'CNY',
      'coins': [
        {'value': '1分', 'name': 'One Fen'},
        {'value': '5分', 'name': 'Five Fen'},
        {'value': '1角', 'name': 'One Jiao'},
        {'value': '5角', 'name': 'Five Jiao'},
        {'value': '¥1', 'name': 'One Yuan'},
      ],
      'notes': [
        {'value': '¥1', 'name': 'One Yuan', 'color': Color(0xFF90EE90)},
        {'value': '¥5', 'name': 'Five Yuan', 'color': Color(0xFF9370DB)},
        {'value': '¥10', 'name': 'Ten Yuan', 'color': Color(0xFF87CEEB)},
        {'value': '¥20', 'name': 'Twenty Yuan', 'color': Color(0xFFDEB887)},
        {'value': '¥50', 'name': 'Fifty Yuan', 'color': Color(0xFF32CD32)},
        {'value': '¥100', 'name': 'Hundred Yuan', 'color': Color(0xFFFF6B6B)},
      ],
      'color': Color(0xFFDE2910),
    },
    // Australia
    {
      'country': 'Australia',
      'flag': '🇦🇺',
      'currency': 'Dollar',
      'symbol': 'A\$',
      'code': 'AUD',
      'coins': [
        {'value': '5c', 'name': 'Five Cents'},
        {'value': '10c', 'name': 'Ten Cents'},
        {'value': '20c', 'name': 'Twenty Cents'},
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': '\$1', 'name': 'One Dollar'},
        {'value': '\$2', 'name': 'Two Dollars'},
      ],
      'notes': [
        {'value': '\$5', 'name': 'Five Dollars', 'color': Color(0xFFFFB6C1)},
        {'value': '\$10', 'name': 'Ten Dollars', 'color': Color(0xFF4169E1)},
        {'value': '\$20', 'name': 'Twenty Dollars', 'color': Color(0xFFFF6347)},
        {'value': '\$50', 'name': 'Fifty Dollars', 'color': Color(0xFFFFD700)},
        {
          'value': '\$100',
          'name': 'Hundred Dollars',
          'color': Color(0xFF32CD32),
        },
      ],
      'color': Color(0xFF00008B),
    },
    // Canada
    {
      'country': 'Canada',
      'flag': '🇨🇦',
      'currency': 'Dollar',
      'symbol': 'C\$',
      'code': 'CAD',
      'coins': [
        {'value': '1¢', 'name': 'Penny'},
        {'value': '5¢', 'name': 'Nickel'},
        {'value': '10¢', 'name': 'Dime'},
        {'value': '25¢', 'name': 'Quarter'},
        {'value': '\$1', 'name': 'Loonie'},
        {'value': '\$2', 'name': 'Toonie'},
      ],
      'notes': [
        {'value': '\$5', 'name': 'Five Dollars', 'color': Color(0xFF87CEEB)},
        {'value': '\$10', 'name': 'Ten Dollars', 'color': Color(0xFF9370DB)},
        {'value': '\$20', 'name': 'Twenty Dollars', 'color': Color(0xFF32CD32)},
        {'value': '\$50', 'name': 'Fifty Dollars', 'color': Color(0xFFFF6B6B)},
        {
          'value': '\$100',
          'name': 'Hundred Dollars',
          'color': Color(0xFFD4A574),
        },
      ],
      'color': Color(0xFFFF0000),
    },
    // Russia
    {
      'country': 'Russia',
      'flag': '🇷🇺',
      'currency': 'Ruble',
      'symbol': '₽',
      'code': 'RUB',
      'coins': [
        {'value': '1₽', 'name': 'One Ruble'},
        {'value': '2₽', 'name': 'Two Rubles'},
        {'value': '5₽', 'name': 'Five Rubles'},
        {'value': '10₽', 'name': 'Ten Rubles'},
      ],
      'notes': [
        {'value': '50₽', 'name': 'Fifty Rubles', 'color': Color(0xFF87CEEB)},
        {'value': '100₽', 'name': 'Hundred Rubles', 'color': Color(0xFFD4A574)},
        {
          'value': '200₽',
          'name': 'Two Hundred Rubles',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '500₽',
          'name': 'Five Hundred Rubles',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '1000₽',
          'name': 'One Thousand Rubles',
          'color': Color(0xFF4169E1),
        },
        {
          'value': '5000₽',
          'name': 'Five Thousand Rubles',
          'color': Color(0xFFFF6B6B),
        },
      ],
      'color': Color(0xFF0039A6),
    },
    // Brazil
    {
      'country': 'Brazil',
      'flag': '🇧🇷',
      'currency': 'Real',
      'symbol': 'R\$',
      'code': 'BRL',
      'coins': [
        {'value': '5c', 'name': 'Five Centavos'},
        {'value': '10c', 'name': 'Ten Centavos'},
        {'value': '25c', 'name': 'Twenty-Five Centavos'},
        {'value': '50c', 'name': 'Fifty Centavos'},
        {'value': 'R\$1', 'name': 'One Real'},
      ],
      'notes': [
        {'value': 'R\$2', 'name': 'Two Reais', 'color': Color(0xFF4169E1)},
        {'value': 'R\$5', 'name': 'Five Reais', 'color': Color(0xFF9370DB)},
        {'value': 'R\$10', 'name': 'Ten Reais', 'color': Color(0xFFFF6347)},
        {'value': 'R\$20', 'name': 'Twenty Reais', 'color': Color(0xFFFFD700)},
        {'value': 'R\$50', 'name': 'Fifty Reais', 'color': Color(0xFFD4A574)},
        {
          'value': 'R\$100',
          'name': 'Hundred Reais',
          'color': Color(0xFF00CED1),
        },
        {
          'value': 'R\$200',
          'name': 'Two Hundred Reais',
          'color': Color(0xFF808080),
        },
      ],
      'color': Color(0xFF009C3B),
    },
    // South Korea
    {
      'country': 'South Korea',
      'flag': '🇰🇷',
      'currency': 'Won',
      'symbol': '₩',
      'code': 'KRW',
      'coins': [
        {'value': '₩10', 'name': 'Ten Won'},
        {'value': '₩50', 'name': 'Fifty Won'},
        {'value': '₩100', 'name': 'Hundred Won'},
        {'value': '₩500', 'name': 'Five Hundred Won'},
      ],
      'notes': [
        {
          'value': '₩1000',
          'name': 'One Thousand Won',
          'color': Color(0xFF4169E1),
        },
        {
          'value': '₩5000',
          'name': 'Five Thousand Won',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '₩10000',
          'name': 'Ten Thousand Won',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '₩50000',
          'name': 'Fifty Thousand Won',
          'color': Color(0xFFFFB6C1),
        },
      ],
      'color': Color(0xFF003478),
    },
    // Mexico
    {
      'country': 'Mexico',
      'flag': '🇲🇽',
      'currency': 'Peso',
      'symbol': 'MX\$',
      'code': 'MXN',
      'coins': [
        {'value': '10c', 'name': 'Ten Centavos'},
        {'value': '20c', 'name': 'Twenty Centavos'},
        {'value': '50c', 'name': 'Fifty Centavos'},
        {'value': '\$1', 'name': 'One Peso'},
        {'value': '\$2', 'name': 'Two Pesos'},
        {'value': '\$5', 'name': 'Five Pesos'},
        {'value': '\$10', 'name': 'Ten Pesos'},
        {'value': '\$20', 'name': 'Twenty Pesos'},
      ],
      'notes': [
        {'value': '\$20', 'name': 'Twenty Pesos', 'color': Color(0xFF4169E1)},
        {'value': '\$50', 'name': 'Fifty Pesos', 'color': Color(0xFFFF69B4)},
        {'value': '\$100', 'name': 'Hundred Pesos', 'color': Color(0xFFFF6347)},
        {
          'value': '\$200',
          'name': 'Two Hundred Pesos',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '\$500',
          'name': 'Five Hundred Pesos',
          'color': Color(0xFFD4A574),
        },
        {
          'value': '\$1000',
          'name': 'One Thousand Pesos',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFF006847),
    },
    // Switzerland
    {
      'country': 'Switzerland',
      'flag': '🇨🇭',
      'currency': 'Franc',
      'symbol': 'CHF',
      'code': 'CHF',
      'coins': [
        {'value': '5c', 'name': 'Five Rappen'},
        {'value': '10c', 'name': 'Ten Rappen'},
        {'value': '20c', 'name': 'Twenty Rappen'},
        {'value': '50c', 'name': 'Fifty Rappen'},
        {'value': '1Fr', 'name': 'One Franc'},
        {'value': '2Fr', 'name': 'Two Francs'},
        {'value': '5Fr', 'name': 'Five Francs'},
      ],
      'notes': [
        {'value': '10Fr', 'name': 'Ten Francs', 'color': Color(0xFFFFD700)},
        {'value': '20Fr', 'name': 'Twenty Francs', 'color': Color(0xFFFF6347)},
        {'value': '50Fr', 'name': 'Fifty Francs', 'color': Color(0xFF32CD32)},
        {
          'value': '100Fr',
          'name': 'Hundred Francs',
          'color': Color(0xFF4169E1),
        },
        {
          'value': '200Fr',
          'name': 'Two Hundred Francs',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '1000Fr',
          'name': 'One Thousand Francs',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFFFF0000),
    },
    // Saudi Arabia
    {
      'country': 'Saudi Arabia',
      'flag': '🇸🇦',
      'currency': 'Riyal',
      'symbol': 'SR',
      'code': 'SAR',
      'coins': [
        {'value': '5h', 'name': 'Five Halalas'},
        {'value': '10h', 'name': 'Ten Halalas'},
        {'value': '25h', 'name': 'Twenty-Five Halalas'},
        {'value': '50h', 'name': 'Fifty Halalas'},
        {'value': 'SR1', 'name': 'One Riyal'},
        {'value': 'SR2', 'name': 'Two Riyals'},
      ],
      'notes': [
        {'value': 'SR1', 'name': 'One Riyal', 'color': Color(0xFF4169E1)},
        {'value': 'SR5', 'name': 'Five Riyals', 'color': Color(0xFF9370DB)},
        {'value': 'SR10', 'name': 'Ten Riyals', 'color': Color(0xFFD4A574)},
        {'value': 'SR50', 'name': 'Fifty Riyals', 'color': Color(0xFF00CED1)},
        {
          'value': 'SR100',
          'name': 'Hundred Riyals',
          'color': Color(0xFFFF6347),
        },
        {
          'value': 'SR500',
          'name': 'Five Hundred Riyals',
          'color': Color(0xFF32CD32),
        },
      ],
      'color': Color(0xFF006C35),
    },
    // United Arab Emirates
    {
      'country': 'UAE',
      'flag': '🇦🇪',
      'currency': 'Dirham',
      'symbol': 'AED',
      'code': 'AED',
      'coins': [
        {'value': '1f', 'name': 'One Fils'},
        {'value': '5f', 'name': 'Five Fils'},
        {'value': '10f', 'name': 'Ten Fils'},
        {'value': '25f', 'name': 'Twenty-Five Fils'},
        {'value': '50f', 'name': 'Fifty Fils'},
        {'value': '1Dh', 'name': 'One Dirham'},
      ],
      'notes': [
        {'value': '5Dh', 'name': 'Five Dirhams', 'color': Color(0xFFD4A574)},
        {'value': '10Dh', 'name': 'Ten Dirhams', 'color': Color(0xFF32CD32)},
        {'value': '20Dh', 'name': 'Twenty Dirhams', 'color': Color(0xFF87CEEB)},
        {'value': '50Dh', 'name': 'Fifty Dirhams', 'color': Color(0xFF9370DB)},
        {
          'value': '100Dh',
          'name': 'Hundred Dirhams',
          'color': Color(0xFFFF69B4),
        },
        {
          'value': '200Dh',
          'name': 'Two Hundred Dirhams',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '500Dh',
          'name': 'Five Hundred Dirhams',
          'color': Color(0xFF00008B),
        },
        {
          'value': '1000Dh',
          'name': 'One Thousand Dirhams',
          'color': Color(0xFF8B4513),
        },
      ],
      'color': Color(0xFF00732F),
    },
    // Singapore
    {
      'country': 'Singapore',
      'flag': '🇸🇬',
      'currency': 'Dollar',
      'symbol': 'S\$',
      'code': 'SGD',
      'coins': [
        {'value': '5c', 'name': 'Five Cents'},
        {'value': '10c', 'name': 'Ten Cents'},
        {'value': '20c', 'name': 'Twenty Cents'},
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': '\$1', 'name': 'One Dollar'},
      ],
      'notes': [
        {'value': '\$2', 'name': 'Two Dollars', 'color': Color(0xFF9370DB)},
        {'value': '\$5', 'name': 'Five Dollars', 'color': Color(0xFF32CD32)},
        {'value': '\$10', 'name': 'Ten Dollars', 'color': Color(0xFFFF6347)},
        {'value': '\$50', 'name': 'Fifty Dollars', 'color': Color(0xFF4169E1)},
        {
          'value': '\$100',
          'name': 'Hundred Dollars',
          'color': Color(0xFFFFA500),
        },
        {
          'value': '\$1000',
          'name': 'One Thousand Dollars',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '\$10000',
          'name': 'Ten Thousand Dollars',
          'color': Color(0xFFFFD700),
        },
      ],
      'color': Color(0xFFED2939),
    },
    // Thailand
    {
      'country': 'Thailand',
      'flag': '🇹🇭',
      'currency': 'Baht',
      'symbol': '฿',
      'code': 'THB',
      'coins': [
        {'value': '25s', 'name': 'Twenty-Five Satang'},
        {'value': '50s', 'name': 'Fifty Satang'},
        {'value': '฿1', 'name': 'One Baht'},
        {'value': '฿2', 'name': 'Two Baht'},
        {'value': '฿5', 'name': 'Five Baht'},
        {'value': '฿10', 'name': 'Ten Baht'},
      ],
      'notes': [
        {'value': '฿20', 'name': 'Twenty Baht', 'color': Color(0xFF32CD32)},
        {'value': '฿50', 'name': 'Fifty Baht', 'color': Color(0xFF4169E1)},
        {'value': '฿100', 'name': 'Hundred Baht', 'color': Color(0xFFFF6347)},
        {
          'value': '฿500',
          'name': 'Five Hundred Baht',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '฿1000',
          'name': 'One Thousand Baht',
          'color': Color(0xFFD4A574),
        },
      ],
      'color': Color(0xFF0D47A1),
    },
    // Malaysia
    {
      'country': 'Malaysia',
      'flag': '🇲🇾',
      'currency': 'Ringgit',
      'symbol': 'RM',
      'code': 'MYR',
      'coins': [
        {'value': '5s', 'name': 'Five Sen'},
        {'value': '10s', 'name': 'Ten Sen'},
        {'value': '20s', 'name': 'Twenty Sen'},
        {'value': '50s', 'name': 'Fifty Sen'},
      ],
      'notes': [
        {'value': 'RM1', 'name': 'One Ringgit', 'color': Color(0xFF4169E1)},
        {'value': 'RM5', 'name': 'Five Ringgit', 'color': Color(0xFF32CD32)},
        {'value': 'RM10', 'name': 'Ten Ringgit', 'color': Color(0xFFFF6347)},
        {'value': 'RM20', 'name': 'Twenty Ringgit', 'color': Color(0xFFFFD700)},
        {'value': 'RM50', 'name': 'Fifty Ringgit', 'color': Color(0xFF00CED1)},
        {
          'value': 'RM100',
          'name': 'Hundred Ringgit',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFFCC0001),
    },
    // Indonesia
    {
      'country': 'Indonesia',
      'flag': '🇮🇩',
      'currency': 'Rupiah',
      'symbol': 'Rp',
      'code': 'IDR',
      'coins': [
        {'value': 'Rp100', 'name': 'Hundred Rupiah'},
        {'value': 'Rp200', 'name': 'Two Hundred Rupiah'},
        {'value': 'Rp500', 'name': 'Five Hundred Rupiah'},
        {'value': 'Rp1000', 'name': 'One Thousand Rupiah'},
      ],
      'notes': [
        {
          'value': 'Rp1000',
          'name': 'One Thousand Rupiah',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'Rp2000',
          'name': 'Two Thousand Rupiah',
          'color': Color(0xFF808080),
        },
        {
          'value': 'Rp5000',
          'name': 'Five Thousand Rupiah',
          'color': Color(0xFFD4A574),
        },
        {
          'value': 'Rp10000',
          'name': 'Ten Thousand Rupiah',
          'color': Color(0xFF9370DB),
        },
        {
          'value': 'Rp20000',
          'name': 'Twenty Thousand Rupiah',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'Rp50000',
          'name': 'Fifty Thousand Rupiah',
          'color': Color(0xFF4169E1),
        },
        {
          'value': 'Rp100000',
          'name': 'Hundred Thousand Rupiah',
          'color': Color(0xFFFF6347),
        },
      ],
      'color': Color(0xFFFF0000),
    },
    // Pakistan
    {
      'country': 'Pakistan',
      'flag': '🇵🇰',
      'currency': 'Rupee',
      'symbol': 'Rs',
      'code': 'PKR',
      'coins': [
        {'value': 'Rs1', 'name': 'One Rupee'},
        {'value': 'Rs2', 'name': 'Two Rupees'},
        {'value': 'Rs5', 'name': 'Five Rupees'},
        {'value': 'Rs10', 'name': 'Ten Rupees'},
      ],
      'notes': [
        {'value': 'Rs10', 'name': 'Ten Rupees', 'color': Color(0xFF32CD32)},
        {'value': 'Rs20', 'name': 'Twenty Rupees', 'color': Color(0xFFFFA500)},
        {'value': 'Rs50', 'name': 'Fifty Rupees', 'color': Color(0xFF9370DB)},
        {
          'value': 'Rs100',
          'name': 'Hundred Rupees',
          'color': Color(0xFFFF6347),
        },
        {
          'value': 'Rs500',
          'name': 'Five Hundred Rupees',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'Rs1000',
          'name': 'One Thousand Rupees',
          'color': Color(0xFF4169E1),
        },
        {
          'value': 'Rs5000',
          'name': 'Five Thousand Rupees',
          'color': Color(0xFFD4A574),
        },
      ],
      'color': Color(0xFF01411C),
    },
    // Bangladesh
    {
      'country': 'Bangladesh',
      'flag': '🇧🇩',
      'currency': 'Taka',
      'symbol': '৳',
      'code': 'BDT',
      'coins': [
        {'value': '৳1', 'name': 'One Taka'},
        {'value': '৳2', 'name': 'Two Taka'},
        {'value': '৳5', 'name': 'Five Taka'},
      ],
      'notes': [
        {'value': '৳2', 'name': 'Two Taka', 'color': Color(0xFF32CD32)},
        {'value': '৳5', 'name': 'Five Taka', 'color': Color(0xFF9370DB)},
        {'value': '৳10', 'name': 'Ten Taka', 'color': Color(0xFFD4A574)},
        {'value': '৳20', 'name': 'Twenty Taka', 'color': Color(0xFF32CD32)},
        {'value': '৳50', 'name': 'Fifty Taka', 'color': Color(0xFFFF6B6B)},
        {'value': '৳100', 'name': 'Hundred Taka', 'color': Color(0xFF4169E1)},
        {
          'value': '৳500',
          'name': 'Five Hundred Taka',
          'color': Color(0xFFFFA500),
        },
        {
          'value': '৳1000',
          'name': 'One Thousand Taka',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFF006A4E),
    },
    // Sri Lanka
    {
      'country': 'Sri Lanka',
      'flag': '🇱🇰',
      'currency': 'Rupee',
      'symbol': 'Rs',
      'code': 'LKR',
      'coins': [
        {'value': 'Rs1', 'name': 'One Rupee'},
        {'value': 'Rs2', 'name': 'Two Rupees'},
        {'value': 'Rs5', 'name': 'Five Rupees'},
        {'value': 'Rs10', 'name': 'Ten Rupees'},
      ],
      'notes': [
        {'value': 'Rs20', 'name': 'Twenty Rupees', 'color': Color(0xFF4169E1)},
        {'value': 'Rs50', 'name': 'Fifty Rupees', 'color': Color(0xFF9370DB)},
        {
          'value': 'Rs100',
          'name': 'Hundred Rupees',
          'color': Color(0xFFFFD700),
        },
        {
          'value': 'Rs500',
          'name': 'Five Hundred Rupees',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'Rs1000',
          'name': 'One Thousand Rupees',
          'color': Color(0xFFFF6347),
        },
        {
          'value': 'Rs5000',
          'name': 'Five Thousand Rupees',
          'color': Color(0xFFD4A574),
        },
      ],
      'color': Color(0xFF8B0000),
    },
    // Nepal
    {
      'country': 'Nepal',
      'flag': '🇳🇵',
      'currency': 'Rupee',
      'symbol': 'Rs',
      'code': 'NPR',
      'coins': [
        {'value': 'Rs1', 'name': 'One Rupee'},
        {'value': 'Rs2', 'name': 'Two Rupees'},
        {'value': 'Rs5', 'name': 'Five Rupees'},
        {'value': 'Rs10', 'name': 'Ten Rupees'},
      ],
      'notes': [
        {'value': 'Rs5', 'name': 'Five Rupees', 'color': Color(0xFF32CD32)},
        {'value': 'Rs10', 'name': 'Ten Rupees', 'color': Color(0xFFD4A574)},
        {'value': 'Rs20', 'name': 'Twenty Rupees', 'color': Color(0xFFFFA500)},
        {'value': 'Rs50', 'name': 'Fifty Rupees', 'color': Color(0xFF4169E1)},
        {
          'value': 'Rs100',
          'name': 'Hundred Rupees',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'Rs500',
          'name': 'Five Hundred Rupees',
          'color': Color(0xFFFF6347),
        },
        {
          'value': 'Rs1000',
          'name': 'One Thousand Rupees',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFFDC143C),
    },
    // South Africa
    {
      'country': 'South Africa',
      'flag': '🇿🇦',
      'currency': 'Rand',
      'symbol': 'R',
      'code': 'ZAR',
      'coins': [
        {'value': '10c', 'name': 'Ten Cents'},
        {'value': '20c', 'name': 'Twenty Cents'},
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': 'R1', 'name': 'One Rand'},
        {'value': 'R2', 'name': 'Two Rand'},
        {'value': 'R5', 'name': 'Five Rand'},
      ],
      'notes': [
        {'value': 'R10', 'name': 'Ten Rand', 'color': Color(0xFF32CD32)},
        {'value': 'R20', 'name': 'Twenty Rand', 'color': Color(0xFFD4A574)},
        {'value': 'R50', 'name': 'Fifty Rand', 'color': Color(0xFFFF6347)},
        {'value': 'R100', 'name': 'Hundred Rand', 'color': Color(0xFF4169E1)},
        {
          'value': 'R200',
          'name': 'Two Hundred Rand',
          'color': Color(0xFFFFA500),
        },
      ],
      'color': Color(0xFF007749),
    },
    // Egypt
    {
      'country': 'Egypt',
      'flag': '🇪🇬',
      'currency': 'Pound',
      'symbol': 'E£',
      'code': 'EGP',
      'coins': [
        {'value': '25pt', 'name': 'Twenty-Five Piastres'},
        {'value': '50pt', 'name': 'Fifty Piastres'},
        {'value': 'E£1', 'name': 'One Pound'},
      ],
      'notes': [
        {'value': 'E£5', 'name': 'Five Pounds', 'color': Color(0xFFD4A574)},
        {'value': 'E£10', 'name': 'Ten Pounds', 'color': Color(0xFF4169E1)},
        {'value': 'E£20', 'name': 'Twenty Pounds', 'color': Color(0xFF32CD32)},
        {'value': 'E£50', 'name': 'Fifty Pounds', 'color': Color(0xFFFF6347)},
        {
          'value': 'E£100',
          'name': 'Hundred Pounds',
          'color': Color(0xFF9370DB),
        },
        {
          'value': 'E£200',
          'name': 'Two Hundred Pounds',
          'color': Color(0xFFFFA500),
        },
      ],
      'color': Color(0xFFCE1126),
    },
    // Turkey
    {
      'country': 'Turkey',
      'flag': '🇹🇷',
      'currency': 'Lira',
      'symbol': '₺',
      'code': 'TRY',
      'coins': [
        {'value': '5kr', 'name': 'Five Kurus'},
        {'value': '10kr', 'name': 'Ten Kurus'},
        {'value': '25kr', 'name': 'Twenty-Five Kurus'},
        {'value': '50kr', 'name': 'Fifty Kurus'},
        {'value': '₺1', 'name': 'One Lira'},
      ],
      'notes': [
        {'value': '₺5', 'name': 'Five Lira', 'color': Color(0xFF9370DB)},
        {'value': '₺10', 'name': 'Ten Lira', 'color': Color(0xFFFF6347)},
        {'value': '₺20', 'name': 'Twenty Lira', 'color': Color(0xFF32CD32)},
        {'value': '₺50', 'name': 'Fifty Lira', 'color': Color(0xFFFFA500)},
        {'value': '₺100', 'name': 'Hundred Lira', 'color': Color(0xFF4169E1)},
        {
          'value': '₺200',
          'name': 'Two Hundred Lira',
          'color': Color(0xFF9370DB),
        },
      ],
      'color': Color(0xFFE30A17),
    },
    // New Zealand
    {
      'country': 'New Zealand',
      'flag': '🇳🇿',
      'currency': 'Dollar',
      'symbol': 'NZ\$',
      'code': 'NZD',
      'coins': [
        {'value': '10c', 'name': 'Ten Cents'},
        {'value': '20c', 'name': 'Twenty Cents'},
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': '\$1', 'name': 'One Dollar'},
        {'value': '\$2', 'name': 'Two Dollars'},
      ],
      'notes': [
        {'value': '\$5', 'name': 'Five Dollars', 'color': Color(0xFFFFA500)},
        {'value': '\$10', 'name': 'Ten Dollars', 'color': Color(0xFF4169E1)},
        {'value': '\$20', 'name': 'Twenty Dollars', 'color': Color(0xFF32CD32)},
        {'value': '\$50', 'name': 'Fifty Dollars', 'color': Color(0xFF9370DB)},
        {
          'value': '\$100',
          'name': 'Hundred Dollars',
          'color': Color(0xFFFF6347),
        },
      ],
      'color': Color(0xFF00247D),
    },
    // Vietnam
    {
      'country': 'Vietnam',
      'flag': '🇻🇳',
      'currency': 'Dong',
      'symbol': '₫',
      'code': 'VND',
      'coins': [
        {'value': '200₫', 'name': 'Two Hundred Dong'},
        {'value': '500₫', 'name': 'Five Hundred Dong'},
        {'value': '1000₫', 'name': 'One Thousand Dong'},
        {'value': '2000₫', 'name': 'Two Thousand Dong'},
        {'value': '5000₫', 'name': 'Five Thousand Dong'},
      ],
      'notes': [
        {
          'value': '10000₫',
          'name': 'Ten Thousand Dong',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '20000₫',
          'name': 'Twenty Thousand Dong',
          'color': Color(0xFF4169E1),
        },
        {
          'value': '50000₫',
          'name': 'Fifty Thousand Dong',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '100000₫',
          'name': 'Hundred Thousand Dong',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '200000₫',
          'name': 'Two Hundred Thousand Dong',
          'color': Color(0xFFFF6347),
        },
        {
          'value': '500000₫',
          'name': 'Five Hundred Thousand Dong',
          'color': Color(0xFF4169E1),
        },
      ],
      'color': Color(0xFFDA251D),
    },
    // Philippines
    {
      'country': 'Philippines',
      'flag': '🇵🇭',
      'currency': 'Peso',
      'symbol': '₱',
      'code': 'PHP',
      'coins': [
        {'value': '1s', 'name': 'One Sentimo'},
        {'value': '5s', 'name': 'Five Sentimos'},
        {'value': '25s', 'name': 'Twenty-Five Sentimos'},
        {'value': '₱1', 'name': 'One Peso'},
        {'value': '₱5', 'name': 'Five Pesos'},
        {'value': '₱10', 'name': 'Ten Pesos'},
        {'value': '₱20', 'name': 'Twenty Pesos'},
      ],
      'notes': [
        {'value': '₱20', 'name': 'Twenty Pesos', 'color': Color(0xFFFFA500)},
        {'value': '₱50', 'name': 'Fifty Pesos', 'color': Color(0xFFFF6347)},
        {'value': '₱100', 'name': 'Hundred Pesos', 'color': Color(0xFF9370DB)},
        {
          'value': '₱200',
          'name': 'Two Hundred Pesos',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '₱500',
          'name': 'Five Hundred Pesos',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '₱1000',
          'name': 'One Thousand Pesos',
          'color': Color(0xFF4169E1),
        },
      ],
      'color': Color(0xFF0038A8),
    },
    // Argentina
    {
      'country': 'Argentina',
      'flag': '🇦🇷',
      'currency': 'Peso',
      'symbol': 'AR\$',
      'code': 'ARS',
      'coins': [
        {'value': '\$1', 'name': 'One Peso'},
        {'value': '\$2', 'name': 'Two Pesos'},
        {'value': '\$5', 'name': 'Five Pesos'},
        {'value': '\$10', 'name': 'Ten Pesos'},
      ],
      'notes': [
        {'value': '\$10', 'name': 'Ten Pesos', 'color': Color(0xFFD4A574)},
        {'value': '\$20', 'name': 'Twenty Pesos', 'color': Color(0xFF4169E1)},
        {'value': '\$50', 'name': 'Fifty Pesos', 'color': Color(0xFF32CD32)},
        {'value': '\$100', 'name': 'Hundred Pesos', 'color': Color(0xFF9370DB)},
        {
          'value': '\$200',
          'name': 'Two Hundred Pesos',
          'color': Color(0xFFFFD700),
        },
        {
          'value': '\$500',
          'name': 'Five Hundred Pesos',
          'color': Color(0xFFFF6347),
        },
        {
          'value': '\$1000',
          'name': 'One Thousand Pesos',
          'color': Color(0xFF4169E1),
        },
      ],
      'color': Color(0xFF75AADB),
    },
    // Kenya
    {
      'country': 'Kenya',
      'flag': '🇰🇪',
      'currency': 'Shilling',
      'symbol': 'KSh',
      'code': 'KES',
      'coins': [
        {'value': '50c', 'name': 'Fifty Cents'},
        {'value': 'KSh1', 'name': 'One Shilling'},
        {'value': 'KSh5', 'name': 'Five Shillings'},
        {'value': 'KSh10', 'name': 'Ten Shillings'},
        {'value': 'KSh20', 'name': 'Twenty Shillings'},
        {'value': 'KSh40', 'name': 'Forty Shillings'},
      ],
      'notes': [
        {
          'value': 'KSh50',
          'name': 'Fifty Shillings',
          'color': Color(0xFF32CD32),
        },
        {
          'value': 'KSh100',
          'name': 'Hundred Shillings',
          'color': Color(0xFFD4A574),
        },
        {
          'value': 'KSh200',
          'name': 'Two Hundred Shillings',
          'color': Color(0xFF4169E1),
        },
        {
          'value': 'KSh500',
          'name': 'Five Hundred Shillings',
          'color': Color(0xFF9370DB),
        },
        {
          'value': 'KSh1000',
          'name': 'One Thousand Shillings',
          'color': Color(0xFFFF6347),
        },
      ],
      'color': Color(0xFF006600),
    },
    // Nigeria
    {
      'country': 'Nigeria',
      'flag': '🇳🇬',
      'currency': 'Naira',
      'symbol': '₦',
      'code': 'NGN',
      'coins': [
        {'value': '50k', 'name': 'Fifty Kobo'},
        {'value': '₦1', 'name': 'One Naira'},
        {'value': '₦2', 'name': 'Two Naira'},
      ],
      'notes': [
        {'value': '₦5', 'name': 'Five Naira', 'color': Color(0xFF32CD32)},
        {'value': '₦10', 'name': 'Ten Naira', 'color': Color(0xFFD4A574)},
        {'value': '₦20', 'name': 'Twenty Naira', 'color': Color(0xFF32CD32)},
        {'value': '₦50', 'name': 'Fifty Naira', 'color': Color(0xFF4169E1)},
        {'value': '₦100', 'name': 'Hundred Naira', 'color': Color(0xFFFF6347)},
        {
          'value': '₦200',
          'name': 'Two Hundred Naira',
          'color': Color(0xFF32CD32),
        },
        {
          'value': '₦500',
          'name': 'Five Hundred Naira',
          'color': Color(0xFF9370DB),
        },
        {
          'value': '₦1000',
          'name': 'One Thousand Naira',
          'color': Color(0xFF4169E1),
        },
      ],
      'color': Color(0xFF008751),
    },
  ];

  int selectedCountryIndex = 0;
  String searchQuery = '';

  // Get filtered countries based on search
  List<Map<String, dynamic>> get filteredCountries {
    if (searchQuery.isEmpty) {
      return allCountriesCurrency;
    }
    return allCountriesCurrency.where((country) {
      final countryName = country['country'].toString().toLowerCase();
      final currencyName = country['currency'].toString().toLowerCase();
      final code = country['code'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return countryName.contains(query) ||
          currencyName.contains(query) ||
          code.contains(query);
    }).toList();
  }

  // For backward compatibility with counting game
  List<Map<String, dynamic>> get indianCoins => [
    {'value': 1, 'label': '1 Rupee', 'emoji': '🪙', 'color': Color(0xFFFFD700)},
    {
      'value': 2,
      'label': '2 Rupees',
      'emoji': '🪙',
      'color': Color(0xFFC0C0C0),
    },
    {
      'value': 5,
      'label': '5 Rupees',
      'emoji': '🪙',
      'color': Color(0xFFCD7F32),
    },
    {
      'value': 10,
      'label': '10 Rupees',
      'emoji': '🪙',
      'color': Color(0xFFB87333),
    },
  ];

  List<Map<String, dynamic>> get indianNotes => [
    {
      'value': 10,
      'label': '₹10',
      'color': Color(0xFFFF9933),
      'description': 'Ten Rupees',
    },
    {
      'value': 20,
      'label': '₹20',
      'color': Color(0xFF00FF7F),
      'description': 'Twenty Rupees',
    },
    {
      'value': 50,
      'label': '₹50',
      'color': Color(0xFF00BFFF),
      'description': 'Fifty Rupees',
    },
    {
      'value': 100,
      'label': '₹100',
      'color': Color(0xFF9370DB),
      'description': 'Hundred Rupees',
    },
    {
      'value': 200,
      'label': '₹200',
      'color': Color(0xFFFF69B4),
      'description': 'Two Hundred Rupees',
    },
    {
      'value': 500,
      'label': '₹500',
      'color': Color(0xFF8B4513),
      'description': 'Five Hundred Rupees',
    },
  ];

  // Quiz data
  int currentQuizIndex = 0;
  String? selectedAnswer;
  bool showQuizResult = false;
  int quizScore = 0;
  int countScore = 0;
  int countCompleted = 0;

  // Learn tab tracking
  Set<String> learnedCoins = {};
  Set<String> learnedNotes = {};

  // Generate dynamic quiz questions based on selected country
  List<Map<String, dynamic>> get dynamicQuizQuestions {
    final country = allCountriesCurrency[selectedCountryIndex];
    final symbol = country['symbol'];
    final flag = country['flag'];
    final notes = country['notes'] as List<Map<String, dynamic>>;
    final coins = country['coins'] as List<Map<String, dynamic>>;

    // Extract numeric values from notes
    List<int> noteValues = [];
    for (var note in notes) {
      final numMatch = RegExp(r'(\d+)').firstMatch(note['value'].toString());
      if (numMatch != null) {
        noteValues.add(int.parse(numMatch.group(1)!));
      }
    }

    // Extract numeric values from coins
    List<int> coinValues = [];
    for (var coin in coins) {
      final numMatch = RegExp(r'(\d+)').firstMatch(coin['value'].toString());
      if (numMatch != null) {
        coinValues.add(int.parse(numMatch.group(1)!));
      }
    }

    if (noteValues.isEmpty) noteValues = [10, 20, 50, 100];
    if (coinValues.isEmpty) coinValues = [1, 2, 5, 10];

    noteValues.sort();
    coinValues.sort();

    List<Map<String, dynamic>> questions = [];

    // Question Type 1: Addition
    for (int i = 0; i < noteValues.length - 1 && questions.length < 10; i++) {
      int a = noteValues[i];
      int b = noteValues[(i + 1) % noteValues.length];
      int correct = a + b;
      questions.add({
        'question': '$flag $symbol$a + $symbol$b = ?',
        'options': [
          '$symbol${correct - 10}',
          '$symbol$correct',
          '$symbol${correct + 10}',
          '$symbol${correct + 20}',
        ],
        'correct': '$symbol$correct',
        'emoji': '➕',
      });
    }

    // Question Type 2: Subtraction
    for (int i = noteValues.length - 1; i > 0 && questions.length < 20; i--) {
      int a = noteValues[i];
      int b = noteValues[i - 1];
      int correct = a - b;
      questions.add({
        'question': '$flag $symbol$a - $symbol$b = ?',
        'options': [
          '$symbol${correct - 10}',
          '$symbol$correct',
          '$symbol${correct + 10}',
          '$symbol${correct - 5}',
        ],
        'correct': '$symbol$correct',
        'emoji': '➖',
      });
    }

    // Question Type 3: How many coins/notes make
    for (int i = 0; i < coinValues.length && questions.length < 30; i++) {
      int coin = coinValues[i];
      if (coin > 0) {
        for (int mult = 2; mult <= 5 && questions.length < 30; mult++) {
          int target = coin * mult;
          questions.add({
            'question':
                '$flag How many $symbol$coin coins make $symbol$target?',
            'options': ['${mult - 1}', '$mult', '${mult + 1}', '${mult + 2}'],
            'correct': '$mult',
            'emoji': '🪙',
          });
        }
      }
    }

    // Question Type 4: Which is worth more
    for (int i = 0; i < noteValues.length - 1 && questions.length < 40; i++) {
      int smaller = noteValues[i];
      int larger = noteValues[i + 1];
      questions.add({
        'question': '$flag Which is worth more?',
        'options': [
          '$symbol$smaller note',
          '$symbol$larger note',
          '$symbol${coinValues.isNotEmpty ? coinValues.last : 10} coin',
          '$symbol${coinValues.isNotEmpty ? coinValues.first : 1} coin',
        ],
        'correct': '$symbol$larger note',
        'emoji': '🤔',
      });
    }

    // Question Type 5: Shopping problems
    List<String> items = [
      'toy 🧸',
      'book 📚',
      'candy 🍬',
      'ball ⚽',
      'pen ✏️',
      'ice cream 🍦',
    ];
    for (int i = 0; i < noteValues.length && questions.length < 50; i++) {
      int money = noteValues[i];
      int spent = (money * 0.3).toInt();
      if (spent > 0) {
        int left = money - spent;
        String item = items[i % items.length];
        questions.add({
          'question':
              '$flag You have $symbol$money. You buy a $item for $symbol$spent. How much left?',
          'options': [
            '$symbol${left - 5}',
            '$symbol$left',
            '$symbol${left + 5}',
            '$symbol${left + 10}',
          ],
          'correct': '$symbol$left',
          'emoji': items[i % items.length].split(' ').last,
        });
      }
    }

    // Shuffle and return
    questions.shuffle();
    return questions.take(50).toList();
  }

  // Counting game
  List<Map<String, dynamic>> selectedItems = [];
  int targetAmount = 0;
  bool showCountResult = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
    _generateCountingGame();

    // Initialize float animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Initialize pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakValue(String text) {
    flutterTts.speak(text);
  }

  void _generateCountingGame() {
    final challenges = dynamicCountChallenges;
    setState(() {
      if (challenges.isNotEmpty) {
        targetAmount = challenges[countCompleted % challenges.length];
      } else {
        targetAmount = 25;
      }
      selectedItems.clear();
      showCountResult = false;
    });
  }

  int get currentTotal {
    int total = 0;
    for (var item in selectedItems) {
      total += item['value'] as int;
    }
    return total;
  }

  void _addMoney(Map<String, dynamic> item) {
    if (showCountResult) return;
    final country = allCountriesCurrency[selectedCountryIndex];
    final currency = country['currency'];
    setState(() {
      selectedItems.add(item);
      if (currentTotal == targetAmount) {
        showCountResult = true;
        score += 10;
        countScore++;
        countCompleted++;
        flutterTts.speak("Correct! You made $targetAmount $currency!");
      } else if (currentTotal > targetAmount) {
        flutterTts.speak("Too much! Try again.");
        selectedItems.clear();
      }
    });
  }

  void _checkQuizAnswer(String answer, List<Map<String, dynamic>> quizList) {
    if (showQuizResult) return;
    setState(() {
      selectedAnswer = answer;
      showQuizResult = true;
      if (answer == quizList[currentQuizIndex]['correct']) {
        score += 10;
        quizScore++;
        flutterTts.speak("Correct!");
      } else {
        flutterTts.speak(
          "Oops! The answer is ${quizList[currentQuizIndex]['correct']}",
        );
      }
    });
  }

  void _nextQuiz(List<Map<String, dynamic>> quizList) {
    setState(() {
      if (currentQuizIndex < quizList.length - 1) {
        currentQuizIndex++;
      } else {
        currentQuizIndex = 0;
        quizScore = 0;
      }
      selectedAnswer = null;
      showQuizResult = false;
    });
  }
  void _refreshAll() {
    setState(() {
      // Reset Quiz
      currentQuizIndex = 0;
      quizScore = 0;
      selectedAnswer = null;
      showQuizResult = false;

      // Reset Count
      countScore = 0;
      countCompleted = 0;
      selectedItems.clear();
      showCountResult = false;
      _generateCountingGame();

      // Reset Learn
      learnedCoins.clear();
      learnedNotes.clear();

      // Reset score
      score = 0;
    });
    flutterTts.speak("Refreshed! Start again.");
  }

  // Generate 50 dynamic count challenges
  List<int> get dynamicCountChallenges {
    final country = allCountriesCurrency[selectedCountryIndex];
    final notes = country['notes'] as List<Map<String, dynamic>>;
    final coins = country['coins'] as List<Map<String, dynamic>>;

    List<int> noteValues = [];
    for (var note in notes) {
      final numMatch = RegExp(r'(\d+)').firstMatch(note['value'].toString());
      if (numMatch != null) {
        noteValues.add(int.parse(numMatch.group(1)!));
      }
    }

    List<int> coinValues = [];
    for (var coin in coins) {
      final numMatch = RegExp(r'(\d+)').firstMatch(coin['value'].toString());
      if (numMatch != null) {
        coinValues.add(int.parse(numMatch.group(1)!));
      }
    }

    if (noteValues.isEmpty) noteValues = [10, 20, 50, 100];
    if (coinValues.isEmpty) coinValues = [1, 2, 5, 10];

    noteValues.sort();
    coinValues.sort();

    List<int> challenges = [];

    // Generate various amounts that can be made with coins and notes
    for (var coin in coinValues) {
      for (int mult = 2; mult <= 6; mult++) {
        challenges.add(coin * mult);
      }
    }

    for (var note in noteValues.take(4)) {
      challenges.add(note);
      if (coinValues.isNotEmpty) {
        challenges.add(note + coinValues.first);
        challenges.add(note + coinValues.last);
      }
    }

    // Add some combination amounts
    if (noteValues.length >= 2) {
      challenges.add(noteValues[0] + noteValues[1]);
    }
    if (coinValues.length >= 2) {
      for (int i = 0; i < coinValues.length - 1; i++) {
        challenges.add(coinValues[i] + coinValues[i + 1]);
        challenges.add(coinValues[i] * 3 + coinValues[i + 1] * 2);
      }
    }

    // Remove duplicates and ensure we have 50 challenges
    challenges = challenges.toSet().toList();
    challenges.sort();

    // If less than 50, add more variations
    while (challenges.length < 50) {
      for (var c in coinValues) {
        if (challenges.length >= 50) break;
        challenges.add(c * (challenges.length % 10 + 2));
      }
    }

    challenges.shuffle();
    return challenges.take(50).toList();
  }

  void _showCountrySearchBottomSheet() {
    String localSearchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Filter countries based on search
            final filtered = localSearchQuery.isEmpty
                ? allCountriesCurrency
                : allCountriesCurrency.where((country) {
                    final countryName = country['country']
                        .toString()
                        .toLowerCase();
                    final currencyName = country['currency']
                        .toString()
                        .toLowerCase();
                    final code = country['code'].toString().toLowerCase();
                    final query = localSearchQuery.toLowerCase();
                    return countryName.contains(query) ||
                        currencyName.contains(query) ||
                        code.contains(query);
                  }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Select Country 🌍",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF764BA2),
                      ),
                    ),
                  ),
                  // Search field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search country, currency...",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF764BA2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          localSearchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Country list
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🔍", style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 12),
                                Text(
                                  "No country found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final country = filtered[index];
                              final originalIndex = allCountriesCurrency
                                  .indexOf(country);
                              final isSelected =
                                  originalIndex == selectedCountryIndex;
                              final countryColor = country['color'] as Color;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCountryIndex = originalIndex;
                                    // Reset quiz and count when country changes
                                    currentQuizIndex = 0;
                                    quizScore = 0;
                                    selectedAnswer = null;
                                    showQuizResult = false;
                                    countScore = 0;
                                    countCompleted = 0;
                                    selectedItems.clear();
                                    showCountResult = false;
                                    _generateCountingGame();
                                  });
                                  _speakValue(
                                    "${country['country']} ${country['currency']}",
                                  );
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              countryColor,
                                              countryColor.withValues(
                                                alpha: 0.7,
                                              ),
                                            ],
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Flag
                                      Text(
                                        country['flag'],
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                      const SizedBox(width: 12),
                                      // Country info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              country['country'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Color(0xFF333333),
                                              ),
                                            ),
                                            Text(
                                              "${country['currency']} (${country['symbol']})",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? Colors.white70
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Coins & Notes emoji indicator
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "🪙",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${(country['coins'] as List).length}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "💵",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${(country['notes'] as List).length}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      // Check icon if selected
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
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
        title: Text(
          "Money Concepts ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // Refresh button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: _refreshAll,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.refresh, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "Learn"),
            Tab(text: "Count"),
            Tab(text: "Quiz"),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [_buildLearnTab(), _buildCountTab(), _buildQuizTab()],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildLearnTab() {
    final selectedCountry = allCountriesCurrency[selectedCountryIndex];
    final coins = selectedCountry['coins'] as List<Map<String, dynamic>>;
    final notes = selectedCountry['notes'] as List<Map<String, dynamic>>;
    final countryColor = selectedCountry['color'] as Color;
    final totalItems = coins.length + notes.length;
    final learnedCount = learnedCoins.length + learnedNotes.length;
    final progress = totalItems > 0 ? learnedCount / totalItems : 0.0;

    return Column(
      children: [
        // Country Dropdown Selector with Search
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: GestureDetector(
            onTap: () => _showCountrySearchBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    selectedCountry['flag'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCountry['country'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          "${selectedCountry['currency']} (${selectedCountry['symbol']})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: countryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.keyboard_arrow_down, color: countryColor),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Progress bar for Learn tab
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📚 Learned: $learnedCount/$totalItems",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(countryColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Country Info Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [countryColor, countryColor.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: countryColor.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                selectedCountry['flag'],
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCountry['country'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${selectedCountry['currency']} (${selectedCountry['symbol']})",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _speakValue(
                  "${selectedCountry['country']}. Currency is ${selectedCountry['currency']}. Symbol is ${selectedCountry['symbol']}",
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coins section
                _buildSectionTitle("${selectedCountry['country']} Coins 🪙"),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final coinKey =
                        "${selectedCountry['code']}_coin_${coin['value']}";
                    final isLearned = learnedCoins.contains(coinKey);
                    final gradient =
                        cardGradients[index % cardGradients.length];
                    return GestureDetector(
                      onTap: () {
                        _speakValue(coin['name']);
                        setState(() {
                          learnedCoins.add(coinKey);
                        });
                      },
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final offset = (index % 2 == 0)
                              ? _floatAnimation.value * 0.5
                              : -_floatAnimation.value * 0.5;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient[0].withValues(alpha: 0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Decorative circle
                                  Positioned(
                                    top: -15,
                                    right: -15,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "🪙",
                                          style: TextStyle(fontSize: 35),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          coin['value'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isLearned)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Notes section
                _buildSectionTitle("${selectedCountry['country']} Notes 💵"),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 2,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final noteKey =
                        "${selectedCountry['code']}_note_${note['value']}";
                    final isLearned = learnedNotes.contains(noteKey);
                    final gradient =
                        cardGradients[(index + 3) % cardGradients.length];
                    return GestureDetector(
                      onTap: () {
                        _speakValue(note['name']);
                        setState(() {
                          learnedNotes.add(noteKey);
                        });
                      },
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final offset = (index % 2 == 0)
                              ? -_floatAnimation.value * 0.5
                              : _floatAnimation.value * 0.5;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient[0].withValues(alpha: 0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Decorative circle
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Second decorative circle
                                  Positioned(
                                    bottom: -15,
                                    left: -15,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "💵",
                                          style: TextStyle(fontSize: 40),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          note['value'],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isLearned)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Get dynamic coins for counting game based on selected country
  List<Map<String, dynamic>> get dynamicCoinsForGame {
    final country = allCountriesCurrency[selectedCountryIndex];
    final coins = country['coins'] as List<Map<String, dynamic>>;
    final symbol = country['symbol'];

    return coins.take(4).map((coin) {
      // Extract numeric value from coin
      final valueStr = coin['value'].toString();
      final numMatch = RegExp(r'(\d+)').firstMatch(valueStr);
      final numValue = numMatch != null ? int.parse(numMatch.group(1)!) : 1;

      return {
        'value': numValue,
        'label': coin['name'],
        'symbol': symbol,
        'displayValue': coin['value'],
        'color': Color(0xFFFFD700),
      };
    }).toList();
  }

  // Get dynamic notes for counting game based on selected country
  List<Map<String, dynamic>> get dynamicNotesForGame {
    final country = allCountriesCurrency[selectedCountryIndex];
    final notes = country['notes'] as List<Map<String, dynamic>>;
    final symbol = country['symbol'];

    return notes.take(4).map((note) {
      // Extract numeric value from note
      final valueStr = note['value'].toString();
      final numMatch = RegExp(r'(\d+)').firstMatch(valueStr);
      final numValue = numMatch != null ? int.parse(numMatch.group(1)!) : 10;

      return {
        'value': numValue,
        'label': note['name'],
        'symbol': symbol,
        'displayValue': note['value'],
        'color': note['color'],
      };
    }).toList();
  }

  Widget _buildCountTab() {
    final selectedCountry = allCountriesCurrency[selectedCountryIndex];
    final symbol = selectedCountry['symbol'];
    final countryColor = selectedCountry['color'] as Color;
    final totalChallenges = 50;
    final progress = countCompleted / totalChallenges;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Country Dropdown - Full width like Learn tab
          GestureDetector(
            onTap: () => _showCountrySearchBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    selectedCountry['flag'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCountry['country'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          "${selectedCountry['currency']} (${selectedCountry['symbol']})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: countryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.keyboard_arrow_down, color: countryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🎯 Completed: $countScore",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$countCompleted/$totalChallenges",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(countryColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Target amount
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedCountry['flag'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Make this amount:",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "$symbol$targetAmount",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: countryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your total: $symbol$currentTotal",
                  style: TextStyle(
                    fontSize: 18,
                    color: currentTotal == targetAmount
                        ? Colors.green
                        : Colors.black54,
                  ),
                ),
                if (showCountResult)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "🎉 Perfect!",
                      style: TextStyle(fontSize: 22, color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Selected items
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: selectedItems.isEmpty
                ? Center(
                    child: Text(
                      "Tap coins 🪙 / notes 💵 below to add",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = selectedItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            item['displayValue'] ?? "$symbol${item['value']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          // Money options - Coins
          Text(
            "🪙 Coins",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dynamicCoinsForGame.length,
              itemBuilder: (context, index) {
                final item = dynamicCoinsForGame[index];
                final gradient = cardGradients[index % cardGradients.length];
                return GestureDetector(
                  onTap: () => _addMoney(item),
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final offset = (index % 2 == 0)
                          ? _floatAnimation.value * 0.4
                          : -_floatAnimation.value * 0.4;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🪙", style: TextStyle(fontSize: 20)),
                                Text(
                                  item['displayValue'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Money options - Notes
          Text(
            "💵 Notes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: dynamicNotesForGame.length,
              itemBuilder: (context, index) {
                final item = dynamicNotesForGame[index];
                final gradient =
                    cardGradients[(index + 4) % cardGradients.length];
                return GestureDetector(
                  onTap: () => _addMoney(item),
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final offset = (index % 2 == 0)
                          ? -_floatAnimation.value * 0.4
                          : _floatAnimation.value * 0.4;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("💵", style: TextStyle(fontSize: 18)),
                                Text(
                                  item['displayValue'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    selectedItems.clear();
                    showCountResult = false;
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Clear"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generateCountingGame,
                  icon: const Icon(Icons.skip_next),
                  label: const Text("New Amount"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF56D97F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    final selectedCountry = allCountriesCurrency[selectedCountryIndex];
    final countryColor = selectedCountry['color'] as Color;
    final quizList = dynamicQuizQuestions;

    if (quizList.isEmpty) {
      return Center(
        child: Text(
          "No quiz available",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    // Ensure currentQuizIndex is within bounds
    final safeIndex = currentQuizIndex < quizList.length ? currentQuizIndex : 0;
    final quiz = quizList[safeIndex];
    final options = quiz['options'] as List<String>;
    final progress = (safeIndex + 1) / quizList.length;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Country Dropdown - Full width like Learn tab
          GestureDetector(
            onTap: () => _showCountrySearchBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    selectedCountry['flag'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCountry['country'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          "${selectedCountry['currency']} (${selectedCountry['symbol']})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: countryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.keyboard_arrow_down, color: countryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Score: $quizScore/${safeIndex + 1}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Q ${safeIndex + 1}/${quizList.length}",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(countryColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Question
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(quiz['emoji'], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(
                  quiz['question'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: countryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Options
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isCorrect = option == quiz['correct'];
                final isSelected = selectedAnswer == option;
                final gradient = cardGradients[index % cardGradients.length];

                return GestureDetector(
                  onTap: () => _checkQuizAnswer(option, quizList),
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      if (showQuizResult) return child!;
                      final offset = (index % 2 == 0)
                          ? _floatAnimation.value * 0.3
                          : -_floatAnimation.value * 0.3;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: showQuizResult
                            ? (isCorrect
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFF43E97B),
                                        Color(0xFF38F9D7),
                                      ],
                                    )
                                  : isSelected
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFFFF6B6B),
                                        Color(0xFFFF8E53),
                                      ],
                                    )
                                  : LinearGradient(colors: gradient))
                            : LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected && !showQuizResult
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Decorative circle
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (showQuizResult && isCorrect)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                if (showQuizResult && isSelected && !isCorrect)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                Flexible(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Next button
          if (showQuizResult)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _nextQuiz(quizList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF56D97F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  safeIndex < quizList.length - 1
                      ? "Next Question ➡️"
                      : "🎉 Start Over",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }}
