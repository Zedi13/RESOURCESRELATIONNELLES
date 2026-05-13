package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-13T10:22:35+0200",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.2 (Oracle Corporation)"
)
@Component
public class CategorieMapperImpl implements CategorieMapper {

    @Override
    public CategorieResponse toResponse(Categorie categorie) {
        if ( categorie == null ) {
            return null;
        }

        CategorieResponse.CategorieResponseBuilder categorieResponse = CategorieResponse.builder();

        categorieResponse.id( categorie.getId() );
        categorieResponse.nom( categorie.getNom() );
        categorieResponse.description( categorie.getDescription() );
        categorieResponse.couleur( categorie.getCouleur() );
        categorieResponse.icone( categorie.getIcone() );
        categorieResponse.ordre( categorie.getOrdre() );
        categorieResponse.estActive( categorie.isEstActive() );

        return categorieResponse.build();
    }
}
