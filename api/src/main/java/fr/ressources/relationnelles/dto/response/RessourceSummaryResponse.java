package fr.ressources.relationnelles.dto.response;

import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class RessourceSummaryResponse {
    private Integer id;
    private String titre;
    private String description;
    private TypeRessource type;
    private Visibilite visibilite;
    private StatutRessource statut;
    private Integer auteurId;
    private String auteurNom;
    private Integer categorieId;
    private String categorieNom;
    private String couleurCategorie;
    private List<TypeRelationResponse> typesRelation;
    private int dureeEstimeeMin;
    private int vues;
    private int partages;
    private LocalDateTime dateCreation;
    private LocalDateTime datePublication;
}
