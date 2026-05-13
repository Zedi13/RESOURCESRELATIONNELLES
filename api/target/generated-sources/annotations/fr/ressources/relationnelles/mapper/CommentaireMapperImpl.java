package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Commentaire;
import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.CommentaireResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-13T10:22:35+0200",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.2 (Oracle Corporation)"
)
@Component
public class CommentaireMapperImpl implements CommentaireMapper {

    @Override
    public CommentaireResponse toResponse(Commentaire commentaire) {
        if ( commentaire == null ) {
            return null;
        }

        CommentaireResponse.CommentaireResponseBuilder commentaireResponse = CommentaireResponse.builder();

        commentaireResponse.ressourceId( commentaireRessourceId( commentaire ) );
        commentaireResponse.auteurId( commentaireAuteurId( commentaire ) );
        commentaireResponse.auteurNom( commentaireAuteurNomComplet( commentaire ) );
        commentaireResponse.parentId( commentaireParentId( commentaire ) );
        commentaireResponse.id( commentaire.getId() );
        commentaireResponse.contenu( commentaire.getContenu() );
        commentaireResponse.statut( commentaire.getStatut() );
        commentaireResponse.dateCreation( commentaire.getDateCreation() );

        commentaireResponse.reponses( mapReponses(commentaire) );

        return commentaireResponse.build();
    }

    private Integer commentaireRessourceId(Commentaire commentaire) {
        if ( commentaire == null ) {
            return null;
        }
        Ressource ressource = commentaire.getRessource();
        if ( ressource == null ) {
            return null;
        }
        Integer id = ressource.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    private Integer commentaireAuteurId(Commentaire commentaire) {
        if ( commentaire == null ) {
            return null;
        }
        Utilisateur auteur = commentaire.getAuteur();
        if ( auteur == null ) {
            return null;
        }
        Integer id = auteur.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    private String commentaireAuteurNomComplet(Commentaire commentaire) {
        if ( commentaire == null ) {
            return null;
        }
        Utilisateur auteur = commentaire.getAuteur();
        if ( auteur == null ) {
            return null;
        }
        String nomComplet = auteur.getNomComplet();
        if ( nomComplet == null ) {
            return null;
        }
        return nomComplet;
    }

    private Integer commentaireParentId(Commentaire commentaire) {
        if ( commentaire == null ) {
            return null;
        }
        Commentaire parent = commentaire.getParent();
        if ( parent == null ) {
            return null;
        }
        Integer id = parent.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }
}
