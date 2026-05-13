package fr.ressources.relationnelles.dto.response;

import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class CommentaireResponse {
    private Integer id;
    private Integer ressourceId;
    private Integer auteurId;
    private String auteurNom;
    private String contenu;
    private StatutCommentaire statut;
    private Integer parentId;
    private LocalDateTime dateCreation;
    private List<CommentaireResponse> reponses;
}
