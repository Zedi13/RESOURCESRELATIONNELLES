package fr.ressources.relationnelles.dto.request;

import jakarta.validation.constraints.NotNull;

public record CreateSessionRequest(
    @NotNull(message = "L'identifiant de la ressource est obligatoire")
    Integer ressourceId
) {}
