package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Commentaire;
import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.CommentaireResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-23T16:29:59+0200",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.46.0.v20260407-0427, environment: Java 21.0.10 (Eclipse Adoptium)"
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
        commentaireResponse.contenu( commentaire.getContenu() );
        commentaireResponse.dateCreation( commentaire.getDateCreation() );
        commentaireResponse.id( commentaire.getId() );
        commentaireResponse.statut( commentaire.getStatut() );

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
