class EmotionDictionary {
  static final Map<String, Map<String, double>> _emotionDictionary = {
    'joy': {
      'happy': 1.0,
      'joyful': 0.9,
      'delighted': 0.8,
      'pleased': 0.7,
      'content': 0.6,
    },
    'anger': {
      'angry': 1.0,
      'furious': 0.9,
      'irritated': 0.8,
      'annoyed': 0.7,
      'upset': 0.6,
    },
    'sadness': {
      'sad': 1.0,
      'unhappy': 0.9,
      'sorrowful': 0.8,
      'depressed': 0.7,
      'down': 0.6,
    },
    'fear': {
      'afraid': 1.0,
      'scared': 0.9,
      'fearful': 0.8,
      'terrified': 0.7,
      'anxious': 0.6,
    },
    'calm': {
      'calm': 1.0,
      'peaceful': 0.9,
      'relaxed': 0.8,
      'serene': 0.7,
      'tranquil': 0.6,
    },
    'surprise': {
      'surprised': 1.0,
      'amazed': 0.9,
      'astonished': 0.8,
      'shocked': 0.7,
      'startled': 0.6,
    },
    'neutral': {
      'neutral': 1.0,
      'indifferent': 0.9,
      'unemotional': 0.8,
      'detached': 0.7,
      'dispassionate': 0.6,
    },
  };

  static Map<String, Map<String, double>> get emotionDictionary =>
      _emotionDictionary;
}
