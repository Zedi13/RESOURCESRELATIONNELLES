package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-22T09:53:52+0200",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.2 (Oracle Corporation)"
)
@Component
public class UtilisateurMapperImpl implements UtilisateurMapper {

    @Override
    public UtilisateurResponse toResponse(Utilisateur utilisateur) {
        if ( utilisateur == null ) {
            return null;
        }

        UtilisateurResponse.UtilisateurResponseBuilder utilisateurResponse = UtilisateurResponse.builder();

        utilisateurResponse.id( utilisateur.getId() );
        utilisateurResponse.nomComplet( utilisateur.getNomComplet() );
        utilisateurResponse.email( utilisateur.getEmail() );
        utilisateurResponse.role( utilisateur.getRole() );
        utilisateurResponse.estVerifie( utilisateur.isEstVerifie() );
        utilisateurResponse.estActif( utilisateur.isEstActif() );
        utilisateurResponse.dateInscription( utilisateur.getDateInscription() );
        utilisateurResponse.derniereConnexion( utilisateur.getDerniereConnexion() );

        return utilisateurResponse.build();
    }
}
