package fr.ressources.relationnelles.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record TypeRelationRequest(
    @NotBlank(message = "Le libellé est obligatoire")
    @Size(max = 50)
    String libelle,

    @Size(max = 255)
    String description,

    short ordre
) {}
