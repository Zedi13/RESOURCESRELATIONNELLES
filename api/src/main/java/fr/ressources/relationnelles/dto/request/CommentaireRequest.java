package fr.ressources.relationnelles.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CommentaireRequest(
    @NotBlank(message = "Le contenu est obligatoire")
    @Size(min = 2, max = 2000, message = "Le commentaire doit faire entre 2 et 2000 caractères")
    String contenu,

    Integer parentId
) {}
