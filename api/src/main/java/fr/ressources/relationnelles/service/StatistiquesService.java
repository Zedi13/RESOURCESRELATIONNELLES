package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.dto.response.StatistiquesResponse;
import fr.ressources.relationnelles.repository.CommentaireRepository;
import fr.ressources.relationnelles.repository.RessourceRepository;
import fr.ressources.relationnelles.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StatistiquesService {

    private final RessourceRepository ressourceRepository;
    private final UtilisateurRepository utilisateurRepository;
    private final CommentaireRepository commentaireRepository;

    public StatistiquesResponse getDashboard() {
        Map<String, Long> parType = toMap(ressourceRepository.countParType());
        Map<String, Long> parCategorie = toMap(ressourceRepository.countParCategorie());

        List<StatistiquesResponse.StatMensuelle> statsParMois = ressourceRepository.statsParMois()
            .stream()
            .map(row -> StatistiquesResponse.StatMensuelle.builder()
                .annee(((Number) row[0]).intValue())
                .mois(((Number) row[1]).intValue())
                .ressourcesCrees(((Number) row[2]).longValue())
                .vues(((Number) row[3]).longValue())
                .build())
            .collect(Collectors.toList());

        return StatistiquesResponse.builder()
            .totalRessources(ressourceRepository.count())
            .ressourcesPubliees(ressourceRepository.countByStatut(StatutRessource.publie))
            .ressourcesEnAttente(ressourceRepository.countByStatut(StatutRessource.en_attente))
            .ressourcesSuspendues(ressourceRepository.countByStatut(StatutRessource.suspendu))
            .ressourcesBrouillon(ressourceRepository.countByStatut(StatutRessource.brouillon))
            .ressourcesParType(parType)
            .ressourcesParCategorie(parCategorie)
            .totalVues(ressourceRepository.sumVues())
            .totalPartages(ressourceRepository.sumPartages())
            .totalUtilisateurs(utilisateurRepository.count())
            .citoyensActifs(utilisateurRepository.countByEstActifTrue())
            .totalCommentaires(commentaireRepository.count())
            .commentairesEnAttente(commentaireRepository.countByStatut(StatutCommentaire.en_attente))
            .statsParMois(statsParMois)
            .build();
    }

    public String exportCsv() {
        StatistiquesResponse stats = getDashboard();
        StringBuilder sb = new StringBuilder();
        sb.append("sep=;\n"); // force Excel à utiliser ; comme séparateur

        // ── Indicateurs globaux ───────────────────────────────────────────────
        sb.append("=== INDICATEURS GLOBAUX ===\n");
        sb.append("Indicateur;Valeur\n");
        row(sb, "Total ressources",           stats.getTotalRessources());
        row(sb, "Ressources publiées",         stats.getRessourcesPubliees());
        row(sb, "Ressources en attente",       stats.getRessourcesEnAttente());
        row(sb, "Ressources suspendues",       stats.getRessourcesSuspendues());
        row(sb, "Total vues",                  stats.getTotalVues());
        row(sb, "Total partages",              stats.getTotalPartages());
        row(sb, "Total utilisateurs",          stats.getTotalUtilisateurs());
        row(sb, "Citoyens actifs",             stats.getCitoyensActifs());
        row(sb, "Total commentaires",          stats.getTotalCommentaires());
        row(sb, "Commentaires en attente",     stats.getCommentairesEnAttente());

        // ── Statistiques mensuelles ───────────────────────────────────────────
        sb.append("\n=== STATISTIQUES MENSUELLES ===\n");
        sb.append("Année;Mois;Ressources créées;Vues\n");
        if (stats.getStatsParMois() != null) {
            stats.getStatsParMois().forEach(s ->
                sb.append(s.getAnnee()).append(";")
                  .append(String.format("%02d", s.getMois())).append(";")
                  .append(s.getRessourcesCrees()).append(";")
                  .append(s.getVues()).append("\n")
            );
        }

        // ── Ressources par type ───────────────────────────────────────────────
        sb.append("\n=== RESSOURCES PAR TYPE ===\n");
        sb.append("Type;Nombre de ressources\n");
        stats.getRessourcesParType().forEach((k, v) -> sb.append(k).append(";").append(v).append("\n"));

        // ── Ressources par catégorie ──────────────────────────────────────────
        sb.append("\n=== RESSOURCES PAR CATÉGORIE ===\n");
        sb.append("Catégorie;Nombre de ressources\n");
        stats.getRessourcesParCategorie().forEach((k, v) -> sb.append(k).append(";").append(v).append("\n"));

        return sb.toString();
    }

    private void row(StringBuilder sb, String label, Object value) {
        sb.append(label).append(";").append(value).append("\n");
    }

    private Map<String, Long> toMap(List<Object[]> rows) {
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : rows) {
            map.put(row[0].toString(), ((Number) row[1]).longValue());
        }
        return map;
    }
}
