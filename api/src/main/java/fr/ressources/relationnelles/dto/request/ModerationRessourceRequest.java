package fr.ressources.relationnelles.dto.request;

import fr.ressources.relationnelles.domain.enums.StatutRessource;
import jakarta.validation.constraints.NotNull;

public record ModerationRessourceRequest(
    @NotNull(message = "Le statut est obligatoire")
    StatutRessource statut
) {}
