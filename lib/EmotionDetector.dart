import 'package:sentiment_dart/sentiment_dart.dart';

class EmotionDetector {
  EmotionDetector();

  Map<String, double> detectEmotions(String text) {
    final SentimentResult sentimentResult =
        Sentiment.analysis(text); // Use the static method
    final emotionLabels = mapScoreToEmotions(sentimentResult.score);

    final emotionFrequencies = <String, int>{};
    for (var emotion in emotionLabels) {
      emotionFrequencies[emotion] = (emotionFrequencies[emotion] ?? 0) + 1;
    }

    final totalEmotions = emotionFrequencies.values.fold(0, (a, b) => a + b);

    final emotionPercentages = <String, double>{};
    emotionFrequencies.forEach((label, frequency) {
      emotionPercentages[label] = (frequency / totalEmotions) * 100;
    });

    return emotionPercentages;
  }

  List<String> mapScoreToEmotions(double score) {
    final emotionLabels = <String>[];

    if (score >= 0.5) {
      emotionLabels.add('ecstatic');
    } else if (0.3 <= score && score < 0.5) {
      emotionLabels.add('joyful');
    } else if (0.1 <= score && score < 0.3) {
      emotionLabels.add('happy');
    } else if (-0.1 <= score && score < 0.1) {
      emotionLabels.add('neutral');
    } else if (-0.3 <= score && score < -0.1) {
      emotionLabels.add('sad');
    } else if (-0.5 <= score && score < -0.3) {
      emotionLabels.add('very sad');
    } else {
      emotionLabels.add('angry');
    }

    if (score > 0.4) {
      emotionLabels.add('positive');
    } else if (score < -0.4) {
      emotionLabels.add('negative');
    }

    if (score > 0.2) {
      emotionLabels.add('excited');
    } else if (score < -0.6) {
      emotionLabels.add('terrified');
    } else if (score < -0.4) {
      emotionLabels.add('disgusted');
    }

    return emotionLabels;
  }
}
