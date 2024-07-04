import 'package:sentiment_dart/sentiment_dart.dart';

class EmotionDetector {
  EmotionDetector();

  // Define sets of keywords for each emotion
  final Map<String, List<String>> emotionKeywords = {
    'happy': [
      'happy',
      'joyful',
      'cheerful',
      'excited',
      'pleased',
      'content',
      'elated',
      'delighted',
      'ecstatic',
      'thrilled',
      'overjoyed',
      'satisfied',
      'glad',
      'positive',
      'upbeat',
      'jubilant'
    ],
    'sad': [
      'sad',
      'unhappy',
      'depressed',
      'down',
      'blue',
      'gloomy',
      'miserable',
      'dismal',
      'sorrowful',
      'heartbroken',
      'distressed',
      'melancholic',
      'despondent',
      'dejected',
      'woe',
      'downcast'
    ],
    'angry': [
      'angry',
      'furious',
      'enraged',
      'mad',
      'annoyed',
      'irritated',
      'outraged',
      'fuming',
      'infuriated',
      'exasperated',
      'resentful',
      'hostile',
      'agitated',
      'cross',
      'vexed',
      'incensed'
    ],
    'neutral': [
      'neutral',
      'indifferent',
      'apathetic',
      'calm',
      'unconcerned',
      'detached',
      'unemotional',
      'stoic',
      'unperturbed',
      'nonchalant',
      'balanced',
      'even-tempered',
      'unbiased',
      'objective',
      'plain'
    ],
    'romantic': [
      'romantic',
      'love',
      'affectionate',
      'passionate',
      'adoring',
      'sweet',
      'devoted',
      'fond',
      'sentimental',
      'charming',
      'enamored',
      'intimate',
      'caring',
      'romantic',
      'enraptured',
      'heartfelt'
    ],
    'irritated': [
      'irritated',
      'annoyed',
      'bothered',
      'frustrated',
      'disturbed',
      'agitated',
      'peeved',
      'irked',
      'miffed',
      'vexed',
      'testy',
      'exasperated',
      'ruffled',
      'infuriated',
      'troubled',
      'put out'
    ],
  };

  Map<String, double> detectEmotions(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final emotionScores = <String, int>{};

    // Initialize the scores for all emotions
    for (var emotion in emotionKeywords.keys) {
      emotionScores[emotion] = 0;
    }

    // Count occurrences of keywords for each emotion
    for (var word in words) {
      for (var entry in emotionKeywords.entries) {
        if (entry.value.contains(word)) {
          emotionScores[entry.key] = (emotionScores[entry.key] ?? 0) + 1;
        }
      }
    }

    // Calculate total words counted for scoring percentages
    final totalKeywords = emotionScores.values.fold(0, (a, b) => a + b);

    final emotionPercentages = <String, double>{};
    if (totalKeywords > 0) {
      emotionScores.forEach((emotion, score) {
        emotionPercentages[emotion] = (score / totalKeywords) * 100;
      });
    }

    // Sort emotions by percentage and take the top 2
    final sortedEmotions = emotionPercentages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(
        sortedEmotions.take(2)); // Keep only the top 2 emotions
  }
}
