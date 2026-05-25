import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Aide & Support'),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpSection(
            title: 'Compte & Connexion',
            icon: Icons.person_outline,
            items: [
              _FaqItem(
                question: 'Comment créer un compte ?',
                answer:
                    'Sur l\'écran de connexion, appuyez sur "Créer un compte". '
                    'Renseignez votre nom, votre adresse e-mail et un mot de passe. '
                    'Votre compte est immédiatement actif.',
              ),
              _FaqItem(
                question: 'J\'ai oublié mon mot de passe, que faire ?',
                answer:
                    'Contactez l\'équipe support à l\'adresse support@ressources-relationnelles.fr '
                    'en indiquant votre adresse e-mail. Un nouveau mot de passe vous sera fourni.',
              ),
              _FaqItem(
                question: 'Comment modifier mes informations personnelles ?',
                answer:
                    'Les modifications de profil sont disponibles depuis la section Paramètres '
                    'de votre page de profil. Cette fonctionnalité sera disponible dans une prochaine mise à jour.',
              ),
            ],
          ),
          SizedBox(height: 16),
          _HelpSection(
            title: 'Ressources',
            icon: Icons.library_books_outlined,
            items: [
              _FaqItem(
                question: 'Comment trouver une ressource ?',
                answer:
                    'Utilisez la barre de recherche en haut de la page principale pour chercher par mot-clé. '
                    'Vous pouvez aussi filtrer par catégorie (les pastilles en dessous de la barre) '
                    'ou utiliser les filtres avancés (icône d\'entonnoir) pour filtrer par type ou type de relation.',
              ),
              _FaqItem(
                question: 'Comment créer une ressource ?',
                answer:
                    'Appuyez sur le bouton + en bas à droite de la liste des ressources, '
                    'ou sur "Créer" dans la section "Mes ressources" de votre profil. '
                    'Remplissez le formulaire et soumettez : votre ressource sera examinée '
                    'par un modérateur avant publication.',
              ),
              _FaqItem(
                question: 'Pourquoi ma ressource n\'est-elle pas visible ?',
                answer:
                    'Toute ressource créée passe par un processus de validation. '
                    'Elle est d\'abord "En attente" jusqu\'à ce qu\'un modérateur l\'examine. '
                    'Elle sera ensuite publiée ou rejetée. Vous pouvez suivre son statut '
                    'dans la section "Mes ressources" de votre profil.',
              ),
              _FaqItem(
                question: 'Quels types de ressources puis-je partager ?',
                answer:
                    'Vous pouvez partager des articles, vidéos, podcasts, fichiers audio, '
                    'activités pratiques, jeux, documents et liens externes. '
                    'Chaque ressource doit être en lien avec le bien-être relationnel.',
              ),
            ],
          ),
          SizedBox(height: 16),
          _HelpSection(
            title: 'Progression & Favoris',
            icon: Icons.trending_up_outlined,
            items: [
              _FaqItem(
                question: 'Comment ajouter une ressource à mes favoris ?',
                answer:
                    'Appuyez sur l\'icône ♡ sur la carte d\'une ressource ou dans son détail. '
                    'Vos favoris sont accessibles depuis l\'onglet "Progression" → "Favoris".',
              ),
              _FaqItem(
                question: 'À quoi sert le bouton "Exploité" ?',
                answer:
                    'Marquer une ressource comme "Exploitée" indique que vous l\'avez utilisée ou consultée. '
                    'Cela vous permet de suivre votre parcours de développement personnel '
                    'dans l\'onglet Progression.',
              ),
              _FaqItem(
                question: 'Mes données de progression sont-elles sauvegardées ?',
                answer:
                    'Oui, vos favoris et ressources exploitées sont synchronisés avec votre compte. '
                    'Ils restent accessibles même si vous vous déconnectez et reconnectez.',
              ),
            ],
          ),
          SizedBox(height: 16),
          _HelpSection(
            title: 'Commentaires',
            icon: Icons.comment_outlined,
            items: [
              _FaqItem(
                question: 'Comment laisser un commentaire ?',
                answer:
                    'Ouvrez le détail d\'une ressource et faites défiler jusqu\'à la section commentaires. '
                    'Tapez votre message et appuyez sur Envoyer. '
                    'Votre commentaire sera visible après validation par un modérateur.',
              ),
              _FaqItem(
                question: 'Mon commentaire n\'apparaît pas, pourquoi ?',
                answer:
                    'Les commentaires sont soumis à modération avant d\'être visibles publiquement. '
                    'Ce processus peut prendre quelques heures.',
              ),
            ],
          ),
          SizedBox(height: 16),
          _HelpSection(
            title: 'Confidentialité',
            icon: Icons.privacy_tip_outlined,
            items: [
              _FaqItem(
                question: 'Qui peut voir mes ressources privées ?',
                answer:
                    'Une ressource "Privée" n\'est visible que par vous. '
                    'Une ressource "Partagée" est visible par les utilisateurs connectés. '
                    'Une ressource "Publique" est visible par tous, même sans compte.',
              ),
              _FaqItem(
                question: 'Comment supprimer mon compte ?',
                answer:
                    'Pour exercer votre droit à l\'effacement, contactez-nous à '
                    'rgpd@ressources-relationnelles.fr. '
                    'Votre compte et vos données seront supprimés dans un délai de 30 jours.',
              ),
            ],
          ),
          SizedBox(height: 16),
          _ContactCard(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_FaqItem> items;

  const _HelpSection({required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Text(
                widget.answer,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF2D6A9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                'Besoin d\'aide supplémentaire ?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Notre équipe est disponible pour répondre à vos questions.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email_outlined, color: Colors.white70, size: 15),
              SizedBox(width: 6),
              Text(
                'support@ressources-relationnelles.fr',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
