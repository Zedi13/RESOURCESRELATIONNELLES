package fr.ressources.relationnelles.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class ProgressionResponse {
    private List<RessourceSummaryResponse> favoris;
    private List<RessourceSummaryResponse> ressourcesExploitees;
    private List<RessourceSummaryResponse> ressourcesSauvegardees;
    private int totalFavoris;
    private int totalExploitees;
    private int totalSauvegardees;
}
