package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-23T16:29:59+0200",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.46.0.v20260407-0427, environment: Java 21.0.10 (Eclipse Adoptium)"
)
@Component
public class UtilisateurMapperImpl implements UtilisateurMapper {

    @Override
    public UtilisateurResponse toResponse(Utilisateur utilisateur) {
        if ( utilisateur == null ) {
            return null;
        }

        UtilisateurResponse.UtilisateurResponseBuilder utilisateurResponse = UtilisateurResponse.builder();

        utilisateurResponse.dateInscription( utilisateur.getDateInscription() );
        utilisateurResponse.derniereConnexion( utilisateur.getDerniereConnexion() );
        utilisateurResponse.email( utilisateur.getEmail() );
        utilisateurResponse.estActif( utilisateur.isEstActif() );
        utilisateurResponse.estVerifie( utilisateur.isEstVerifie() );
        utilisateurResponse.id( utilisateur.getId() );
        utilisateurResponse.nomComplet( utilisateur.getNomComplet() );
        utilisateurResponse.role( utilisateur.getRole() );

        return utilisateurResponse.build();
    }
}
