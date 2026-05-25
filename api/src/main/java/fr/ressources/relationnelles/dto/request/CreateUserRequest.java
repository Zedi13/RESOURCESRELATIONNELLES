package fr.ressources.relationnelles.dto.request;

import fr.ressources.relationnelles.domain.enums.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateUserRequest(
    @NotBlank
    @Size(max = 100)
    String nomComplet,

    @NotBlank
    @Email
    @Size(max = 150)
    String email,

    @NotBlank
    @Size(min = 8, message = "Le mot de passe doit contenir au moins 8 caractères")
    String motDePasse,

    @NotNull(message = "Le rôle est obligatoire")
    Role role
) {}
