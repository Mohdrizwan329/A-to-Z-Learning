/// Generic learning item model
class LearningItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String? imageUrl;
  final String? audioUrl;
  final String category;
  final int order;
  final Map<String, dynamic>? metadata;

  const LearningItemModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.emoji,
    this.imageUrl,
    this.audioUrl,
    required this.category,
    this.order = 0,
    this.metadata,
  });

  factory LearningItemModel.fromJson(Map<String, dynamic> json) {
    return LearningItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      emoji: json['emoji'] ?? '📚',
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      category: json['category'] ?? '',
      order: json['order'] ?? 0,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'emoji': emoji,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'category': category,
      'order': order,
      'metadata': metadata,
    };
  }
}

/// Alphabet item model
class AlphabetItemModel {
  final String letter;
  final String word;
  final String emoji;
  final String pronunciation;
  final bool isCapital;

  const AlphabetItemModel({
    required this.letter,
    required this.word,
    required this.emoji,
    this.pronunciation = '',
    this.isCapital = true,
  });

  factory AlphabetItemModel.fromJson(Map<String, dynamic> json) {
    return AlphabetItemModel(
      letter: json['letter'] ?? '',
      word: json['word'] ?? '',
      emoji: json['emoji'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      isCapital: json['isCapital'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'letter': letter,
      'word': word,
      'emoji': emoji,
      'pronunciation': pronunciation,
      'isCapital': isCapital,
    };
  }
}

/// Number item model
class NumberItemModel {
  final int number;
  final String word;
  final String hindi;
  final String emoji;

  const NumberItemModel({
    required this.number,
    required this.word,
    this.hindi = '',
    this.emoji = '',
  });

  factory NumberItemModel.fromJson(Map<String, dynamic> json) {
    return NumberItemModel(
      number: json['number'] ?? 0,
      word: json['word'] ?? '',
      hindi: json['hindi'] ?? '',
      emoji: json['emoji'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'word': word,
      'hindi': hindi,
      'emoji': emoji,
    };
  }
}

/// Quiz question model
class QuizQuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? imageUrl;
  final String? hint;
  final String category;
  final String difficulty; // easy, medium, hard

  const QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
    this.hint,
    required this.category,
    this.difficulty = 'easy',
  });

  String get correctAnswer => options[correctIndex];

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
      imageUrl: json['imageUrl'],
      hint: json['hint'],
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'imageUrl': imageUrl,
      'hint': hint,
      'category': category,
      'difficulty': difficulty,
    };
  }
}

/// Story/Poem model
class StoryModel {
  final String id;
  final String title;
  final String content;
  final String emoji;
  final String? moral;
  final String? audioUrl;
  final List<String>? images;
  final String category;

  const StoryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.emoji,
    this.moral,
    this.audioUrl,
    this.images,
    required this.category,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      emoji: json['emoji'] ?? '📖',
      moral: json['moral'],
      audioUrl: json['audioUrl'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'emoji': emoji,
      'moral': moral,
      'audioUrl': audioUrl,
      'images': images,
      'category': category,
    };
  }
}
