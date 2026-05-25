package fr.ressources.relationnelles.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record MessageSessionRequest(
    @NotBlank(message = "Le contenu du message ne peut pas être vide")
    @Size(max = 2000, message = "Le message ne peut pas dépasser 2000 caractères")
    String contenu
) {}
