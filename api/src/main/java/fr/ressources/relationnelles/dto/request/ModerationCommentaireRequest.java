package fr.ressources.relationnelles.dto.request;

import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import jakarta.validation.constraints.NotNull;

public record ModerationCommentaireRequest(
    @NotNull(message = "La décision est obligatoire")
    StatutCommentaire decision
) {}
