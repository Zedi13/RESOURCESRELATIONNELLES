package fr.ressources.relationnelles.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CategorieRequest(
    @NotBlank(message = "Le nom est obligatoire")
    @Size(max = 100)
    String nom,

    String description,

    @NotBlank
    @Pattern(regexp = "^#[0-9A-Fa-f]{6}$", message = "La couleur doit être un code hexadécimal valide (ex: #2E86AB)")
    String couleur,

    @NotBlank
    @Size(max = 50)
    String icone,

    short ordre
) {}
