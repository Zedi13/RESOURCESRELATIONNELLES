package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-23T16:29:59+0200",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.46.0.v20260407-0427, environment: Java 21.0.10 (Eclipse Adoptium)"
)
@Component
public class CategorieMapperImpl implements CategorieMapper {

    @Override
    public CategorieResponse toResponse(Categorie categorie) {
        if ( categorie == null ) {
            return null;
        }

        CategorieResponse.CategorieResponseBuilder categorieResponse = CategorieResponse.builder();

        categorieResponse.couleur( categorie.getCouleur() );
        categorieResponse.description( categorie.getDescription() );
        categorieResponse.estActive( categorie.isEstActive() );
        categorieResponse.icone( categorie.getIcone() );
        categorieResponse.id( categorie.getId() );
        categorieResponse.nom( categorie.getNom() );
        categorieResponse.ordre( categorie.getOrdre() );

        return categorieResponse.build();
    }
}
