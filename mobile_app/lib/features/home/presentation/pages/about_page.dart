import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            title: const Text('À propos'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primary, Color(0xFF2D6A9F)],
                  ),
                ),
                child: const SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Icon(Icons.favorite_rounded, size: 52, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        '(RE)Sources Relationnelles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'v1.0.0',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(
                    icon: Icons.info_outline,
                    title: 'Notre mission',
                    content:
                        '(RE)Sources Relationnelles est une plateforme dédiée au bien-être relationnel. '
                        'Elle permet aux citoyens de découvrir, partager et s\'approprier des ressources '
                        'pour améliorer leurs relations : en couple, en famille, entre amis, au travail ou avec soi-même.',
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.people_outline,
                    title: 'À qui s\'adresse cette application ?',
                    content:
                        'L\'application s\'adresse à toute personne souhaitant enrichir sa vie relationnelle. '
                        'Que vous soyez à la recherche de conseils, d\'exercices pratiques, de podcasts ou '
                        'd\'articles, vous trouverez des ressources adaptées à votre situation.',
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.stars_outlined,
                    title: 'Fonctionnalités',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FeatureRow(icon: Icons.library_books_outlined, label: 'Catalogue de ressources multimédias'),
                        _FeatureRow(icon: Icons.favorite_outline, label: 'Favoris et suivi de progression'),
                        _FeatureRow(icon: Icons.comment_outlined, label: 'Commentaires et échanges'),
                        _FeatureRow(icon: Icons.edit_outlined, label: 'Création et partage de ressources'),
                        _FeatureRow(icon: Icons.filter_list, label: 'Filtres par catégorie et type'),
                        _FeatureRow(icon: Icons.shield_outlined, label: 'Modération et qualité garantie'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.category_outlined,
                    title: 'Types de ressources',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TypeChip(label: 'Articles', icon: Icons.article_outlined),
                        _TypeChip(label: 'Vidéos', icon: Icons.play_circle_outline),
                        _TypeChip(label: 'Podcasts', icon: Icons.mic_outlined),
                        _TypeChip(label: 'Audio', icon: Icons.headphones_outlined),
                        _TypeChip(label: 'Activités', icon: Icons.directions_run),
                        _TypeChip(label: 'Jeux', icon: Icons.games_outlined),
                        _TypeChip(label: 'Documents', icon: Icons.description_outlined),
                        _TypeChip(label: 'Liens', icon: Icons.link),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Vie privée & RGPD',
                    content:
                        'Vos données personnelles sont traitées dans le strict respect du Règlement Général '
                        'sur la Protection des Données (RGPD). Elles ne sont ni vendues ni partagées avec des tiers. '
                        'Vous disposez d\'un droit d\'accès, de rectification et de suppression à tout moment.\n\n'
                        'Contact : rgpd@ressources-relationnelles.fr',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Projet universitaire — CESI',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppTheme.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Développé dans le cadre du cursus Informatique\n© 2026 — Tous droits réservés',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final Widget? child;

  const _Section({required this.icon, required this.title, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(content!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6)),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.secondary),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TypeChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.secondary),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.secondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
