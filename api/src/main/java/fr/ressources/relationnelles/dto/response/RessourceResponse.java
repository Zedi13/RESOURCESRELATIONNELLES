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
public class RessourceResponse {
    private Integer id;
    private String titre;
    private String description;
    private String contenu;
    private TypeRessource type;
    private Visibilite visibilite;
    private StatutRessource statut;
    private Integer auteurId;
    private String auteurNom;
    private CategorieResponse categorie;
    private List<TypeRelationResponse> typesRelation;
    private String urlExterne;
    private int dureeEstimeeMin;
    private int vues;
    private int partages;
    private LocalDateTime dateCreation;
    private LocalDateTime dateModification;
    private LocalDateTime datePublication;
    // Champs contextuels (null si non connecté)
    private Boolean estFavori;
    private Boolean estExploite;
    private Boolean estSauvegarde;
}
