import 'package:flutter/material.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';

class ResourcesLocalDatasource {
  final List<Category> _categories = const [
    Category(
      id: 'cat1',
      name: 'Communication',
      description: 'Améliorer votre façon d\'exprimer et d\'écouter',
      color: Color(0xFF2E86AB),
      icon: Icons.chat_bubble_outline,
    ),
    Category(
      id: 'cat2',
      name: 'Gestion des conflits',
      description: 'Résoudre les désaccords avec bienveillance',
      color: Color(0xFFE53935),
      icon: Icons.balance,
    ),
    Category(
      id: 'cat3',
      name: 'Développement personnel',
      description: 'Grandir pour mieux vous relier aux autres',
      color: Color(0xFF43A047),
      icon: Icons.self_improvement,
    ),
    Category(
      id: 'cat4',
      name: 'Parentalité',
      description: 'Construire des liens solides avec vos enfants',
      color: Color(0xFF8E24AA),
      icon: Icons.family_restroom,
    ),
    Category(
      id: 'cat5',
      name: 'Vie de couple',
      description: 'Nourrir et renforcer votre relation amoureuse',
      color: Color(0xFFE91E63),
      icon: Icons.favorite_outline,
    ),
    Category(
      id: 'cat6',
      name: 'Amitié',
      description: 'Cultiver des amitiés profondes et durables',
      color: Color(0xFF00ACC1),
      icon: Icons.people_outline,
    ),
    Category(
      id: 'cat7',
      name: 'Vie professionnelle',
      description: 'Optimiser vos relations au travail',
      color: Color(0xFF1565C0),
      icon: Icons.work_outline,
    ),
  ];

  final List<Resource> _resources = [
    Resource(
      id: 'res1',
      title: 'L\'écoute active : la clé d\'une communication réussie',
      description:
          'Découvrez les techniques de l\'écoute active pour améliorer vos échanges quotidiens et renforcer vos liens.',
      content: '''## L\'écoute active

L\'écoute active est une technique de communication qui consiste à être pleinement attentif à son interlocuteur, sans jugement et sans préparer sa réponse pendant qu\'il parle.

### Les principes fondamentaux

**1. Présence totale**
Mettez de côté votre téléphone et toute distraction. Votre corps et votre esprit doivent être tournés vers l\'autre.

**2. La reformulation**
Reformulez ce que vous avez entendu pour vérifier votre compréhension : "Si je comprends bien, tu dis que..."

**3. Les questions ouvertes**
Posez des questions qui invitent à l\'approfondissement : "Comment t\'es-tu senti dans cette situation ?"

**4. La validation émotionnelle**
Reconnaissez les émotions de l\'autre sans les minimiser : "Je comprends que tu te sentes frustré."

### Exercice pratique

Lors de votre prochaine conversation importante, pratiquez les 5 minutes d\'écoute pure : écoutez sans interrompre, sans formuler votre réponse, juste en étant présent.

### Bénéfices
- Réduction des malentendus de 70%
- Renforcement de la confiance
- Résolution plus rapide des conflits''',
      type: ResourceType.article,
      categoryId: 'cat1',
      relationTypes: [RelationType.couple, RelationType.amis, RelationType.professionnel],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 1, 20),
      views: 1247,
      shares: 89,
      estimatedDurationMin: 8,
    ),
    Resource(
      id: 'res2',
      title: 'Communication Non-Violente (CNV) : exprimer ses besoins sans blesser',
      description:
          'La CNV de Marshall Rosenberg vous guide vers une expression authentique de vos émotions et besoins.',
      content: '''## La Communication Non-Violente

Développée par Marshall Rosenberg, la CNV repose sur 4 composantes essentielles.

### Le modèle OSBD

**O - Observation**
Décrivez les faits sans jugement ni interprétation.
❌ "Tu es toujours en retard"
✅ "Ce soir tu es arrivé à 21h alors que nous avions convenu 19h"

**S - Sentiment**
Exprimez ce que vous ressentez réellement.
"Je me suis senti inquiet, puis soulagé..."

**B - Besoin**
Identifiez le besoin sous-jacent.
"J\'ai besoin de pouvoir compter sur nos engagements communs."

**D - Demande**
Formulez une demande claire, concrète et négociable.
"Pourrais-tu me prévenir si tu as du retard ?"

### Pratiquer au quotidien

Commencez par écrire vos communications difficiles selon ce modèle avant de les verbaliser. Avec la pratique, cela deviendra naturel.''',
      type: ResourceType.article,
      categoryId: 'cat1',
      relationTypes: [RelationType.couple, RelationType.famille, RelationType.professionnel],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 1, 28),
      views: 2103,
      shares: 156,
      estimatedDurationMin: 12,
    ),
    Resource(
      id: 'res3',
      title: 'Désamorcer un conflit en 5 étapes',
      description:
          'Techniques éprouvées pour sortir d\'une escalade conflictuelle et retrouver un dialogue constructif.',
      content: '''## Désamorcer un conflit

Lorsqu\'une tension monte, voici comment reprendre le contrôle de la situation.

### Étape 1 : Pause
Demandez un temps de pause : "J\'ai besoin de 10 minutes pour me calmer avant de continuer."

### Étape 2 : Respiration
Pratiquez la respiration 4-7-8 : inspirez 4s, retenez 7s, expirez 8s. Répétez 3 fois.

### Étape 3 : Reformulation bienveillante
Reformulez le point de vue de l\'autre avant d\'exprimer le vôtre.

### Étape 4 : Cherchez le besoin commun
Quel est l\'objectif partagé ? Souvent, les deux parties veulent la même chose.

### Étape 5 : Proposez une solution
"Que pourrions-nous faire différemment pour que cela fonctionne mieux ?"''',
      type: ResourceType.article,
      categoryId: 'cat2',
      relationTypes: [RelationType.couple, RelationType.famille, RelationType.professionnel],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '2',
      authorName: 'Bob Dupont',
      createdAt: DateTime(2024, 2, 5),
      views: 873,
      shares: 67,
      estimatedDurationMin: 7,
    ),
    Resource(
      id: 'res4',
      title: 'Méditation de la bienveillance (Metta) - 10 minutes',
      description:
          'Guidez votre esprit vers plus de compassion envers vous-même et les autres grâce à cette méditation guidée.',
      content: '''## Méditation Metta - Loving-Kindness

Cette pratique développe la bienveillance envers soi-même et les autres.

### Installation
Installez-vous confortablement, les yeux fermés. Respirez profondément 3 fois.

### Phase 1 : Bienveillance envers soi (3 min)
Répétez intérieurement :
- "Que je sois heureux"
- "Que je sois en bonne santé"
- "Que je sois en paix"

### Phase 2 : Bienveillance envers un proche (3 min)
Pensez à quelqu\'un que vous aimez. Envoyez-lui les mêmes souhaits.

### Phase 3 : Bienveillance universelle (4 min)
Élargissez progressivement : votre quartier, votre ville, le monde entier.

### Pratique régulière
10 minutes par jour pendant 30 jours transforme profondément vos relations.''',
      type: ResourceType.audio,
      categoryId: 'cat3',
      relationTypes: [RelationType.soi, RelationType.social],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '3',
      authorName: 'Marie Leblanc',
      createdAt: DateTime(2024, 2, 12),
      views: 1589,
      shares: 203,
      estimatedDurationMin: 10,
    ),
    Resource(
      id: 'res5',
      title: 'Le jeu de la gratitude en couple',
      description:
          'Un jeu simple pour renforcer votre connexion et redécouvrir ce qui vous unit.',
      content: '''## Le Jeu de la Gratitude

Ce jeu se joue à 2 et dure environ 20 minutes.

### Matériel
- Un dé
- Des fiches cartonnées
- Un stylo chacun

### Règles

**Chacun écrit 6 gratitudes** (une par face du dé) sur sa fiche :
des choses pour lesquelles vous êtes reconnaissant envers votre partenaire.

**Puis, à tour de rôle** :
1. Lancez le dé
2. Lisez la gratitude correspondante à voix haute
3. L\'autre écoute sans interrompre, puis dit simplement "merci"

### Variante avancée
Ajoutez une phase d\'exploration : "Ce qui m\'a touché dans ce que tu as dit c\'est..."

### Fréquence recommandée
Une fois par semaine, idéalement le dimanche soir pour bien démarrer la semaine.''',
      type: ResourceType.activite,
      categoryId: 'cat5',
      relationTypes: [RelationType.couple],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 2, 20),
      views: 2456,
      shares: 312,
      estimatedDurationMin: 20,
    ),
    Resource(
      id: 'res6',
      title: 'Comprendre les 5 langages de l\'amour',
      description:
          'Découvrez votre langage de l\'amour et celui de vos proches pour mieux vous comprendre.',
      content: '''## Les 5 Langages de l\'Amour

Théorie de Gary Chapman : chacun exprime et reçoit l\'amour différemment.

### Les 5 langages

**1. Les mots d\'affirmation**
"Je t\'aime", compliments, encouragements verbaux.

**2. Le temps de qualité**
Présence totale, activités partagées sans distractions.

**3. Les cadeaux**
Attention : la valeur importe peu, c\'est l\'intention qui compte.

**4. Les services rendus**
Faire des choses pour l\'autre : cuisine, soutien dans les tâches.

**5. Le contact physique**
Câlins, main dans la main, proximité physique.

### Comment identifier votre langage ?
Observez comment vous exprimez l\'amour naturellement — c\'est souvent votre façon de le recevoir.

### Exercice
Demandez à votre partenaire/proche de classer ces 5 langages par ordre d\'importance pour lui. Partagez le vôtre. Discutez des différences.''',
      type: ResourceType.article,
      categoryId: 'cat5',
      relationTypes: [RelationType.couple, RelationType.famille, RelationType.amis],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '2',
      authorName: 'Bob Dupont',
      createdAt: DateTime(2024, 2, 25),
      views: 3102,
      shares: 445,
      estimatedDurationMin: 10,
    ),
    Resource(
      id: 'res7',
      title: 'Établir des limites saines dans les relations',
      description:
          'Apprendre à dire non avec bienveillance pour protéger votre énergie et vos relations.',
      content: '''## Les limites saines

Établir des limites n\'est pas égoïste — c\'est indispensable pour des relations équilibrées.

### Pourquoi des limites ?
- Préserver votre énergie et votre bien-être
- Éviter le ressentiment accumulé
- Permettre des relations plus authentiques

### Types de limites
- **Physiques** : espace personnel, contact
- **Émotionnelles** : énergie accordée, sujets abordés
- **Temporelles** : disponibilité
- **Numériques** : réponses messages, partage de données

### Communiquer ses limites
1. Soyez clair et précis
2. Exprimez votre besoin, pas une accusation
3. Proposez une alternative si possible
4. Tenez-vous à ce que vous avez dit

**Exemple** : "J\'ai besoin de temps seul le samedi matin pour recharger mes batteries. Je serai pleinement disponible l\'après-midi."''',
      type: ResourceType.article,
      categoryId: 'cat3',
      relationTypes: [RelationType.soi, RelationType.couple, RelationType.amis],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 3, 1),
      views: 1876,
      shares: 278,
      estimatedDurationMin: 9,
    ),
    Resource(
      id: 'res8',
      title: 'Parentalité positive : encourager sans imposer',
      description:
          'Techniques pour guider vos enfants avec bienveillance tout en respectant leur autonomie.',
      content: '''## Parentalité Positive

La parentalité positive cherche l\'équilibre entre autorité bienveillante et respect de l\'enfant.

### Les principes
- L\'enfant est un être entier avec ses propres besoins
- La discipline est éducation, pas punition
- La connexion précède la correction

### Outils pratiques

**Le "Oui... quand"**
❌ "Non, tu ne peux pas regarder la télé"
✅ "Oui, tu pourras regarder la télé quand tes devoirs seront faits"

**Les conséquences logiques**
Liées naturellement au comportement, pas arbitraires.

**Le time-in**
Plutôt qu\'isoler l\'enfant, restez avec lui pour comprendre ce qui s\'est passé.

**La roue des émotions**
Aidez l\'enfant à nommer ses émotions : "Tu sembles frustré. Est-ce que c\'est ça ?"''',
      type: ResourceType.article,
      categoryId: 'cat4',
      relationTypes: [RelationType.famille],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '2',
      authorName: 'Bob Dupont',
      createdAt: DateTime(2024, 3, 8),
      views: 943,
      shares: 112,
      estimatedDurationMin: 11,
    ),
    Resource(
      id: 'res9',
      title: 'Gérer les personnalités difficiles au travail',
      description:
          'Stratégies pour collaborer efficacement même avec des collègues ou managers difficiles.',
      content: '''## Collaborer malgré les difficultés

Il n\'y a pas de mauvaises personnes, seulement des besoins non exprimés.

### Typologies et stratégies

**Le perfectionniste anxieux**
Besoin : contrôle, reconnaissance. Stratégie : donnez-lui des données précises et anticipez ses questions.

**Le dominant autoritaire**
Besoin : efficacité, respect. Stratégie : soyez direct, factuel, proposez des solutions.

**Le passif-agressif**
Besoin : sécurité, reconnaissance. Stratégie : créez un cadre clair, valorisez explicitement.

**Le négatif chronique**
Besoin : être entendu. Stratégie : écoutez ses craintes puis invitez à proposer des solutions.

### Le principe fondamental
Cherchez le besoin non satisfait derrière chaque comportement difficile. La compréhension est le premier pas vers la collaboration.''',
      type: ResourceType.article,
      categoryId: 'cat7',
      relationTypes: [RelationType.professionnel],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '3',
      authorName: 'Marie Leblanc',
      createdAt: DateTime(2024, 3, 15),
      views: 1234,
      shares: 98,
      estimatedDurationMin: 10,
    ),
    Resource(
      id: 'res10',
      title: 'Cultiver l\'amitié à l\'âge adulte',
      description:
          'Pourquoi est-il difficile de se faire des amis adulte et comment y remédier concrètement.',
      content: '''## L\'amitié adulte, un défi moderne

Après 30 ans, se faire de nouveaux amis devient un vrai challenge. Voici pourquoi et comment.

### Pourquoi c\'est difficile ?
- Moins de contextes sociaux spontanés
- Barrières de la pudeur adulte
- Manque de temps perçu
- Peur du rejet amplifiée

### Stratégies efficaces

**La règle des 50 heures**
Les recherches montrent qu\'il faut ~50h passées ensemble pour considérer quelqu\'un comme ami. Planifiez de la régularité.

**L\'initiative courageuse**
Proposez explicitement de se revoir : "J\'ai vraiment apprécié cette soirée. On se refait ça la semaine prochaine ?"

**Les rituels d\'amitié**
Créez des rendez-vous réguliers : film du vendredi, café du dimanche.

**La vulnérabilité sélective**
Partagez quelque chose de personnel — c\'est ce qui transforme une connaissance en ami.''',
      type: ResourceType.article,
      categoryId: 'cat6',
      relationTypes: [RelationType.amis],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 3, 22),
      views: 2789,
      shares: 387,
      estimatedDurationMin: 8,
    ),
    Resource(
      id: 'res11',
      title: 'Journal de bord relationnel (privé)',
      description: 'Mon espace personnel pour noter mes réflexions sur mes relations.',
      content: 'Contenu privé...',
      type: ResourceType.document,
      categoryId: 'cat3',
      relationTypes: [RelationType.soi],
      visibility: ResourceVisibility.prive,
      status: ResourceStatus.brouillon,
      authorId: '1',
      authorName: 'Alice Martin',
      createdAt: DateTime(2024, 3, 25),
      views: 0,
      shares: 0,
      estimatedDurationMin: 0,
    ),
    Resource(
      id: 'res12',
      title: 'Podcast : Les neurosciences au service de l\'empathie',
      description:
          'Une conversation fascinante sur les bases neurologiques de l\'empathie et comment les cultiver.',
      content: '''## Les neurosciences de l\'empathie

Dans cet épisode, nous explorons comment notre cerveau génère l\'empathie.

### Les neurones miroirs
Ces cellules nerveuses s\'activent quand nous observons une action ou une émotion chez l\'autre. Elles sont la base neurologique de l\'empathie.

### Empathie cognitive vs affective
- **Cognitive** : comprendre le point de vue de l\'autre intellectuellement
- **Affective** : ressentir l\'émotion de l\'autre

### Cultiver l\'empathie
1. Pratiquer la pleine conscience
2. Lire de la fiction (active les zones d\'empathie du cerveau)
3. Ralentir les jugements automatiques
4. Questions "Et si tu étais à sa place ?"

### Durée : 45 minutes''',
      type: ResourceType.podcast,
      categoryId: 'cat3',
      relationTypes: [RelationType.soi, RelationType.social],
      visibility: ResourceVisibility.public_,
      status: ResourceStatus.publie,
      authorId: '3',
      authorName: 'Marie Leblanc',
      createdAt: DateTime(2024, 4, 1),
      views: 678,
      shares: 45,
      estimatedDurationMin: 45,
    ),
  ];

  List<Category> getCategories() => List.unmodifiable(_categories);

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Resource> getPublicResources() =>
      _resources.where((r) => r.isPublic && r.isPublished).toList();

  List<Resource> getAllResources() => List.unmodifiable(_resources);

  List<Resource> getResourcesByAuthor(String authorId) =>
      _resources.where((r) => r.authorId == authorId).toList();

  Resource? getResourceById(String id) {
    try {
      return _resources.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void addResource(Resource resource) {
    _resources.add(resource);
  }

  void updateResource(Resource resource) {
    final idx = _resources.indexWhere((r) => r.id == resource.id);
    if (idx != -1) _resources[idx] = resource;
  }

  void deleteResource(String id) {
    _resources.removeWhere((r) => r.id == id);
  }

  void incrementViews(String id) {
    final idx = _resources.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _resources[idx] = _resources[idx].copyWith(views: _resources[idx].views + 1);
    }
  }

  void incrementShares(String id) {
    final idx = _resources.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _resources[idx] = _resources[idx].copyWith(shares: _resources[idx].shares + 1);
    }
  }

  List<Resource> searchResources(String query) {
    final q = query.toLowerCase();
    return _resources.where((r) {
      return r.title.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q);
    }).toList();
  }

  List<Resource> filterResources({
    String? categoryId,
    ResourceType? type,
    RelationType? relationType,
    ResourceStatus? status,
  }) {
    return _resources.where((r) {
      if (categoryId != null && r.categoryId != categoryId) return false;
      if (type != null && r.type != type) return false;
      if (relationType != null && !r.relationTypes.contains(relationType)) return false;
      if (status != null && r.status != status) return false;
      return true;
    }).toList();
  }
}
