package fr.ressources.relationnelles.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class StatistiquesResponse {
    // Ressources
    private long totalRessources;
    private long ressourcesPubliees;
    private long ressourcesEnAttente;
    private long ressourcesSuspendues;
    private long ressourcesBrouillon;
    private Map<String, Long> ressourcesParType;
    private Map<String, Long> ressourcesParCategorie;
    // Engagement
    private long totalVues;
    private long totalPartages;
    // Utilisateurs
    private long totalUtilisateurs;
    private long citoyensActifs;
    // Commentaires
    private long totalCommentaires;
    private long commentairesEnAttente;
    // Évolution mensuelle
    private List<StatMensuelle> statsParMois;

    @Data
    @Builder
    public static class StatMensuelle {
        private int annee;
        private int mois;
        private long ressourcesCrees;
        private long vues;
    }
}
