import 'package:flutter/material.dart';
import '../models/scam_guide.dart';

class ScamData {
  static const List<ScamGuide> commonScams = [
    ScamGuide(
      id: 'scam_1',
      title: 'Faux agent Mobile Money',
      summary: "Quelqu'un appelle en se disant agent Orange, Moov ou Wave. Il demande votre code pour...",
      icon: Icons.person_outline,
      howItWorks:
          "Quelqu'un appelle en se disant agent Orange, Moov ou Wave. Il demande votre code pour « vérifier » ou « débloquer » votre compte.",
      exampleSender: "Appel +223 76...",
      exampleMessage:
          "« Bonjour, je suis agent Orange Money. Confirmez le code que vous venez de recevoir pour valider votre compte. »",
      warningSigns: [
        "Demande de PIN ou OTP",
        "Urgence",
        "Appel d'un numéro inconnu",
      ],
      whatToDo: [
        "Raccrochez tout de suite",
        "Ne donnez jamais votre code",
        "Appelez le 133 (Orange) ou le service officiel",
      ],
      bambaraSummary:
          "Mɔgɔ dɔ b'i weele k'a fɔ ko a ye agent don. A b'i ka kɔdi ɲini. Kana a di !",
    ),
    ScamGuide(
      id: 'scam_2',
      title: 'Faux transfert reçu',
      summary: "Un faux SMS ou une fausse capture annonce un transfert reçu. L'escroc vous...",
      icon: Icons.receipt_long_outlined,
      howItWorks:
          "Vous recevez un faux SMS imitant une notification de dépôt Orange Money ou Wave. Quelques minutes plus tard, un inconnu appelle en pleurs affirmant s'être trompé de numéro et supplie de lui renvoyer la somme.",
      exampleSender: "SMS Inconnu",
      exampleMessage:
          "« Depot reussi de 45.000 FCFA sur votre compte. Nouveau solde : 47.500 FCFA. Ref: TX89123 »",
      warningSigns: [
        "Le SMS provient d'un numéro ordinaire (+223...) au lieu du nom officiel de l'opérateur",
        "Votre solde réel n'a pas augmenté dans l'application",
        "Insistance immédiate par appel vocal",
      ],
      whatToDo: [
        "Vérifiez toujours votre solde réel via le code USSD (#144# ou *115#)",
        "Ne renvoyez jamais d'argent sans vérification préalable",
        "Laissez l'opérateur officiel gérer les erreurs de transaction",
      ],
      bambaraSummary:
          "Mɔgɔ dɔ b'a fɔ k'a ye wari bila i ka kɔnti la fili la. Yɛlɛma k'a kɔnɔ fɔlɔ !",
    ),
    ScamGuide(
      id: 'scam_3',
      title: 'Faux concours / faux gain',
      summary: "Un message annonce que vous avez gagné un prix (FCFA, téléphone). On exige un...",
      icon: Icons.card_giftcard_outlined,
      howItWorks:
          "Un message annonce un gain exceptionnel lors d'une tombola ou anniversaire de marque. Pour « débloquer » le lot, on vous ordonne de payer des frais d'envoi ou d'huissier.",
      exampleSender: "Promo Mali",
      exampleMessage:
          "« Félicitations ! Votre numéro a été tiré au sort pour la promo Tabaski. Vous gagnez 1 000 000 FCFA. Envoyez 25 000 FCFA de frais de dossier pour recevoir le gain. »",
      warningSigns: [
        "Vous n'avez participé à aucun jeu-concours",
        "On demande de l'argent pour recevoir de l'argent",
        "Pression temporelle extrême (valable 1 heure)",
      ],
      whatToDo: [
        "Ne payez aucun frais préalable pour retirer un gain",
        "Signalez le numéro frauduleux",
        "Bloquez l'expéditeur immédiatement",
      ],
      bambaraSummary: "I ma nɛgɛsira si kɛ k'a fɔ k'i ye wari sɔrɔ. Ngalon dɔrɔn don !",
    ),
    ScamGuide(
      id: 'scam_4',
      title: "Fausse offre d'emploi",
      summary: "Une offre d'emploi facile et bien payée circule sur WhatsApp. On vous réclame...",
      icon: Icons.work_outline,
      howItWorks:
          "Des offres promettant un salaire alléchant pour des tâches simples de saisie ou d'évaluation de vidéos. Après quelques échanges, un recruteur exige des frais d'inscription ou l'achat d'un kit de travail.",
      exampleSender: "WhatsApp Recrutement",
      exampleMessage:
          "« Recrutement urgent ONG à Bamako : salaire 350.000 FCFA/mois. Envoyez votre CV et 5.000 FCFA de caution de dossier par Wave. »",
      warningSigns: [
        "Aucun entretien physique ni adresse vérifiée",
        "Frais de dossier exigés d'avance",
        "Communication uniquement par WhatsApp ou Telegram",
      ],
      whatToDo: [
        "Une vraie entreprise ne fait jamais payer les candidats",
        "Vérifiez l'existence légale de l'employeur",
        "Ne transmettez jamais votre photo de CNI sans filigrane",
      ],
      bambaraSummary: "Baara sira tɛ wari sara fɔlɔ. Kana wari di baara ɲinila si ma.",
    ),
    ScamGuide(
      id: 'scam_5',
      title: 'Faux remboursement',
      summary: "Un SMS annonce un remboursement de l'opérateur ou de l'État, un lien frauduleux...",
      icon: Icons.error_outline,
      howItWorks:
          "Un SMS prétend qu'un trop-perçu ou une subvention d'État doit vous être reversé. Pour le percevoir, un lien vous redirige vers un faux site demandant vos accès bancaires.",
      exampleSender: "Aide-Mali",
      exampleMessage:
          "« Remboursement facture EDM / Sotelma : vous avez un avoir de 18.500 FCFA. Réclamez votre virement sur http://remboursement-mali-aide.ga »",
      warningSigns: [
        "Liens bizarres ou raccourcis (.ga, .xyz, bit.ly)",
        "Demande des identifiants confidentiels",
        "Fautes d'orthographe ou formulation inhabituelle",
      ],
      whatToDo: [
        "Ne cliquez pas sur le lien",
        "Renseignez-vous directement en agence EDM ou télécom",
        "Supprimez le message",
      ],
      bambaraSummary:
          "Kana da foyi la min b'a fɔ ko wari b'i kɔnɔ k'a sɔrɔ i ma foyi kɛ.",
    ),
    ScamGuide(
      id: 'scam_6',
      title: 'Faux blocage de compte',
      summary: "Un SMS dit que votre compte sera bloqué. Pour « l'éviter », il faudrait...",
      icon: Icons.credit_card_outlined,
      howItWorks:
          "Menace imminente de fermeture de votre compte Mobile Money pour défaut d'identification. La victime panique et appelle le numéro indiqué qui lui soutire son code secret.",
      exampleSender: "Securite-Compte",
      exampleMessage:
          "« ALERTE : Votre compte Orange Money sera suspendu dans 2 heures. Cliquez sur le lien ou composez le 77XX pour régulariser. »",
      warningSigns: [
        "Menace de suspension ou blocage sous 24h",
        "L'opérateur officiel prévient toujours en agence ou par courrier",
        "Demande d'action précipitée",
      ],
      whatToDo: [
        "Gardez votre calme : les comptes ne sont pas bloqués sans préavis formel",
        "Rendez-vous dans une agence officielle avec votre CNI",
        "Ne composez pas les numéros personnels indiqués dans le SMS",
      ],
      bambaraSummary: "Kɔnti datuguli kuma caman ye nkalon ye. Taga agence yɛrɛ la.",
    ),
    ScamGuide(
      id: 'scam_7',
      title: "Phishing (vol d'informations)",
      summary: "Un message imite une organisation connue pour voler vos mots de passe et...",
      icon: Icons.qr_code_scanner_outlined,
      howItWorks:
          "Des pages web parfaitement clonées aux couleurs d'institutions bancaires ou étatiques maliennes pour capturer logins, mots de passe et codes de validation.",
      exampleSender: "Portail Citoyen",
      exampleMessage:
          "« Mise à jour NINA / biométrie obligatoire : connectez-vous sur mali-identite-verification.com sous peine d'amende. »",
      warningSigns: [
        "Adresse web fausse (orthographe légèrement modifiée)",
        "Absence de cadenas de sécurité HTTPS certifié",
        "Exigence de saisir vos données bancaires ou codes OTP",
      ],
      whatToDo: [
        "Tapez vous-même l'adresse officielle dans le navigateur",
        "Ne suivez jamais un lien d'authentification reçu par SMS",
        "Vérifiez l'URL avec l'outil d'analyse de Sentinelle",
      ],
      bambaraSummary:
          "Aw b'a lajɛ ka ɲɛ, siteweb dɔw bɛ kɛ i n'a fɔ lada siteweb nka juguw taye don.",
    ),
  ];
}
