package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-13T10:22:35+0200",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.2 (Oracle Corporation)"
)
@Component
public class TypeRelationMapperImpl implements TypeRelationMapper {

    @Override
    public TypeRelationResponse toResponse(TypeRelation typeRelation) {
        if ( typeRelation == null ) {
            return null;
        }

        TypeRelationResponse.TypeRelationResponseBuilder typeRelationResponse = TypeRelationResponse.builder();

        typeRelationResponse.id( typeRelation.getId() );
        typeRelationResponse.libelle( typeRelation.getLibelle() );
        typeRelationResponse.description( typeRelation.getDescription() );
        typeRelationResponse.ordre( typeRelation.getOrdre() );

        return typeRelationResponse.build();
    }
}
