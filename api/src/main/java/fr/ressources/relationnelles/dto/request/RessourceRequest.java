package fr.ressources.relationnelles.dto.request;

import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import jakarta.validation.constraints.*;

import java.util.List;

public record RessourceRequest(
    @NotBlank(message = "Le titre est obligatoire")
    @Size(max = 255)
    String titre,

    @NotBlank(message = "La description est obligatoire")
    String description,

    @NotBlank(message = "Le contenu est obligatoire")
    String contenu,

    @NotNull(message = "Le type est obligatoire")
    TypeRessource type,

    @NotNull(message = "La visibilité est obligatoire")
    Visibilite visibilite,

    @NotNull(message = "La catégorie est obligatoire")
    Integer categorieId,

    @NotEmpty(message = "Au moins un type de relation est requis")
    List<Integer> typesRelationIds,

    String urlExterne,

    @Min(0)
    int dureeEstimeeMin
) {}
