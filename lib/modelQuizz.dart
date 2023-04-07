// permet d'ecrire la question
// et de faire sous forme de liste des options possible

class Question {
  final String text;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.text,
    required this.options,
    this.isLocked = false,
    this.selectedOption,
  });
}

// String text: champs texte des options
// bool isCorrect: icon pour demontrer si l'option est vraie ou fausse
class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
  });
}

final questions = [
  Question(
    text:
        'Combien de boucles sont nécessaires pour créer une maille en l\'air ?',
    options: [
      const Option(text: 'a) Une boucle', isCorrect: false),
      const Option(text: 'b) Deux boucles', isCorrect: true),
      const Option(text: 'c) Trois boucles', isCorrect: false),
      const Option(text: 'd) Quatre boucles', isCorrect: false),
    ],
  ),
  Question(
    text: 'Quelle est la technique de base utilisée pour crocheter en rond ?',
    options: [
      const Option(text: 'a) La maille serrée', isCorrect: false),
      const Option(text: 'b) La maille en l\'air', isCorrect: false),
      const Option(text: 'c) La maille coulée', isCorrect: false),
      const Option(text: 'd) Le cercle magique', isCorrect: true),
    ],
  ),
  Question(
    text: 'Quel est l\'outil de base nécessaire pour crocheter ?',
    options: [
      const Option(text: "a) Une aiguille à tricoter", isCorrect: false),
      const Option(text: 'b) Un crochet', isCorrect: true),
      const Option(text: 'c) Un métier à tisser', isCorrect: false),
      const Option(text: 'd) Une machine à coudre', isCorrect: false),
    ],
  ),
  Question(
    text:
        'Quelle est la principale différence entre une bride et une demi-bride en crochet ?',
    options: [
      const Option(
          text: 'a) Une bride est plus haute qu\'une demi-bride.',
          isCorrect: false),
      const Option(
          text: 'b) Une demi-bride est plus haute qu\'une bride.',
          isCorrect: false),
      const Option(
          text: 'c) Une bride a une boucle de plus que la demi-bride.',
          isCorrect: true),
      const Option(
          text: 'd) Une demi-bride a une boucle de plus que la bride.',
          isCorrect: false),
    ],
  ),
  Question(
    text:
        'Quelle sont les technique de base recommandée pour commencer un projet de crochet ?',
    options: [
      const Option(text: 'a) Les mailles de base', isCorrect: false),
      const Option(text: 'b) Le nœud coulant', isCorrect: false),
      const Option(text: 'c) Le cercle magique', isCorrect: true),
      const Option(text: 'd) Le point coulé', isCorrect: false),
    ],
  ),
  Question(
    text: 'Quel est le crochet le plus couramment utilisé pour les débutants ?',
    options: [
      const Option(text: 'a) Crochet en aluminium', isCorrect: false),
      const Option(text: 'b) Crochet en acier', isCorrect: false),
      const Option(text: 'c) Crochet ergonomique', isCorrect: true),
      const Option(text: 'd) Crochet tunisien', isCorrect: false),
    ],
  ),
];
