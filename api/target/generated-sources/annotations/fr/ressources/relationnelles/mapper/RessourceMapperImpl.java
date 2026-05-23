package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.RessourceResponse;
import fr.ressources.relationnelles.dto.response.RessourceSummaryResponse;
import javax.annotation.processing.Generated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-23T16:29:59+0200",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.46.0.v20260407-0427, environment: Java 21.0.10 (Eclipse Adoptium)"
)
@Component
public class RessourceMapperImpl implements RessourceMapper {

    @Autowired
    private CategorieMapper categorieMapper;

    @Override
    public RessourceResponse toResponse(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }

        RessourceResponse.RessourceResponseBuilder ressourceResponse = RessourceResponse.builder();

        ressourceResponse.auteurId( ressourceAuteurId( ressource ) );
        ressourceResponse.auteurNom( ressourceAuteurNomComplet( ressource ) );
        ressourceResponse.categorie( categorieMapper.toResponse( ressource.getCategorie() ) );
        ressourceResponse.typesRelation( mapTypesRelation( ressource.getTypesRelation() ) );
        ressourceResponse.contenu( ressource.getContenu() );
        ressourceResponse.dateCreation( ressource.getDateCreation() );
        ressourceResponse.dateModification( ressource.getDateModification() );
        ressourceResponse.datePublication( ressource.getDatePublication() );
        ressourceResponse.description( ressource.getDescription() );
        ressourceResponse.dureeEstimeeMin( ressource.getDureeEstimeeMin() );
        ressourceResponse.id( ressource.getId() );
        ressourceResponse.partages( ressource.getPartages() );
        ressourceResponse.statut( ressource.getStatut() );
        ressourceResponse.titre( ressource.getTitre() );
        ressourceResponse.type( ressource.getType() );
        ressourceResponse.urlExterne( ressource.getUrlExterne() );
        ressourceResponse.visibilite( ressource.getVisibilite() );
        ressourceResponse.vues( ressource.getVues() );

        return ressourceResponse.build();
    }

    @Override
    public RessourceSummaryResponse toSummary(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }

        RessourceSummaryResponse.RessourceSummaryResponseBuilder ressourceSummaryResponse = RessourceSummaryResponse.builder();

        ressourceSummaryResponse.auteurId( ressourceAuteurId( ressource ) );
        ressourceSummaryResponse.auteurNom( ressourceAuteurNomComplet( ressource ) );
        ressourceSummaryResponse.categorieId( ressourceCategorieId( ressource ) );
        ressourceSummaryResponse.categorieNom( ressourceCategorieNom( ressource ) );
        ressourceSummaryResponse.couleurCategorie( ressourceCategorieCouleur( ressource ) );
        ressourceSummaryResponse.typesRelation( mapTypesRelation( ressource.getTypesRelation() ) );
        ressourceSummaryResponse.dateCreation( ressource.getDateCreation() );
        ressourceSummaryResponse.datePublication( ressource.getDatePublication() );
        ressourceSummaryResponse.description( ressource.getDescription() );
        ressourceSummaryResponse.dureeEstimeeMin( ressource.getDureeEstimeeMin() );
        ressourceSummaryResponse.id( ressource.getId() );
        ressourceSummaryResponse.partages( ressource.getPartages() );
        ressourceSummaryResponse.statut( ressource.getStatut() );
        ressourceSummaryResponse.titre( ressource.getTitre() );
        ressourceSummaryResponse.type( ressource.getType() );
        ressourceSummaryResponse.visibilite( ressource.getVisibilite() );
        ressourceSummaryResponse.vues( ressource.getVues() );

        return ressourceSummaryResponse.build();
    }

    private Integer ressourceAuteurId(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }
        Utilisateur auteur = ressource.getAuteur();
        if ( auteur == null ) {
            return null;
        }
        Integer id = auteur.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    private String ressourceAuteurNomComplet(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }
        Utilisateur auteur = ressource.getAuteur();
        if ( auteur == null ) {
            return null;
        }
        String nomComplet = auteur.getNomComplet();
        if ( nomComplet == null ) {
            return null;
        }
        return nomComplet;
    }

    private Integer ressourceCategorieId(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }
        Categorie categorie = ressource.getCategorie();
        if ( categorie == null ) {
            return null;
        }
        Integer id = categorie.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    private String ressourceCategorieNom(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }
        Categorie categorie = ressource.getCategorie();
        if ( categorie == null ) {
            return null;
        }
        String nom = categorie.getNom();
        if ( nom == null ) {
            return null;
        }
        return nom;
    }

    private String ressourceCategorieCouleur(Ressource ressource) {
        if ( ressource == null ) {
            return null;
        }
        Categorie categorie = ressource.getCategorie();
        if ( categorie == null ) {
            return null;
        }
        String couleur = categorie.getCouleur();
        if ( couleur == null ) {
            return null;
        }
        return couleur;
    }
}
