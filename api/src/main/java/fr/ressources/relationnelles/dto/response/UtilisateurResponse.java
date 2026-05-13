package fr.ressources.relationnelles.dto.response;

import fr.ressources.relationnelles.domain.enums.Role;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class UtilisateurResponse {
    private Integer id;
    private String nomComplet;
    private String email;
    private Role role;
    private boolean estVerifie;
    private boolean estActif;
    private LocalDateTime dateInscription;
    private LocalDateTime derniereConnexion;
}
