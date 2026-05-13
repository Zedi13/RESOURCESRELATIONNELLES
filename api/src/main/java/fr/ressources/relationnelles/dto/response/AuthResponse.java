package fr.ressources.relationnelles.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AuthResponse {
    private String token;
    private String type;
    private UtilisateurResponse utilisateur;

    public static AuthResponse of(String token, UtilisateurResponse utilisateur) {
        return AuthResponse.builder()
            .token(token)
            .type("Bearer")
            .utilisateur(utilisateur)
            .build();
    }
}
