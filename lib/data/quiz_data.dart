import '../models/quiz_question.dart';

class QuizData {
  static const List<QuizQuestion> questions = [
    QuizQuestion(
      number: 1,
      question:
          "Un « agent » vous appelle et demande votre code PIN pour vérifier votre compte. Que faites-vous ?",
      options: [
        "Je donne le code",
        "Je raccroche et j'appelle l'opérateur",
        "Je donne seulement 2 chiffres",
      ],
      correctIndex: 1,
      explanation:
          "Aucun opérateur officiel ne vous demandera JAMAIS votre code secret ou PIN sous aucun prétexte.",
    ),
    QuizQuestion(
      number: 2,
      question:
          "Vous recevez un SMS annonçant un gain de 500 000 FCFA avec un lien bit.ly. Que faites-vous ?",
      options: [
        "Je clique vite pour récupérer mon gain",
        "Je supprime et signale sur Sentinelle",
        "Je transfère le message à ma famille",
      ],
      correctIndex: 1,
      explanation:
          "Si vous n'avez joué à aucun concours, vous n'avez rien gagné. Les liens raccourcis cachent des pièges.",
    ),
    QuizQuestion(
      number: 3,
      question:
          "Un inconnu vous appelle affirmant qu'il a envoyé de l'argent par erreur sur votre compte. Que faire ?",
      options: [
        "Je lui renvoie immédiatement la somme",
        "Je vérifie mon solde réel (#144# ou *115#) et contacte l'opérateur",
        "Je retire immédiatement l'argent au kiosque",
      ],
      correctIndex: 1,
      explanation:
          "Vérifiez toujours votre solde réel. Les faux SMS de transfert sont une des arnaques les plus courantes.",
    ),
    QuizQuestion(
      number: 4,
      question:
          "Une offre d'emploi alléchante sur WhatsApp vous réclame 5 000 FCFA de « frais de dossier ». Que faites-vous ?",
      options: [
        "Je refuse catégoriquement : un recrutement légitime ne fait jamais payer",
        "Je paie pour sécuriser ma candidature",
        "J'envoie une photo de ma carte d'identité",
      ],
      correctIndex: 0,
      explanation:
          "Aucun employeur sérieux n'exige de frais de dossier avant un entretien d'embauche.",
    ),
    QuizQuestion(
      number: 5,
      question:
          "On vous demande par SMS de transmettre le code de validation (OTP) que vous venez de recevoir. Que faire ?",
      options: [
        "Je refuse : ce code permettrait à un pirate de valider un paiement",
        "Je le donne si l'interlocuteur a l'air poli",
        "Je le transmets pour débloquer mon compte",
      ],
      correctIndex: 0,
      explanation:
          "Le code OTP est personnel et temporaire. Il ne doit JAMAIS être partagé avec quiconque.",
    ),
  ];
}
