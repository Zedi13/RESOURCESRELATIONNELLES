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
        sb.append("Indicateur,Valeur\n");
        sb.append("Total ressources,").append(stats.getTotalRessources()).append("\n");
        sb.append("Ressources publiées,").append(stats.getRessourcesPubliees()).append("\n");
        sb.append("Ressources en attente,").append(stats.getRessourcesEnAttente()).append("\n");
        sb.append("Ressources suspendues,").append(stats.getRessourcesSuspendues()).append("\n");
        sb.append("Total vues,").append(stats.getTotalVues()).append("\n");
        sb.append("Total partages,").append(stats.getTotalPartages()).append("\n");
        sb.append("Total utilisateurs,").append(stats.getTotalUtilisateurs()).append("\n");
        sb.append("Citoyens actifs,").append(stats.getCitoyensActifs()).append("\n");
        sb.append("Total commentaires,").append(stats.getTotalCommentaires()).append("\n");
        sb.append("Commentaires en attente,").append(stats.getCommentairesEnAttente()).append("\n");
        sb.append("\nType,Nombre ressources\n");
        stats.getRessourcesParType().forEach((k, v) -> sb.append(k).append(",").append(v).append("\n"));
        sb.append("\nCatégorie,Nombre ressources\n");
        stats.getRessourcesParCategorie().forEach((k, v) -> sb.append(k).append(",").append(v).append("\n"));
        return sb.toString();
    }

    private Map<String, Long> toMap(List<Object[]> rows) {
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : rows) {
            map.put(row[0].toString(), ((Number) row[1]).longValue());
        }
        return map;
    }
}
