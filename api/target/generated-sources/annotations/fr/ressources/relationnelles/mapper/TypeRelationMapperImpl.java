package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-05-23T16:29:59+0200",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.46.0.v20260407-0427, environment: Java 21.0.10 (Eclipse Adoptium)"
)
@Component
public class TypeRelationMapperImpl implements TypeRelationMapper {

    @Override
    public TypeRelationResponse toResponse(TypeRelation typeRelation) {
        if ( typeRelation == null ) {
            return null;
        }

        TypeRelationResponse.TypeRelationResponseBuilder typeRelationResponse = TypeRelationResponse.builder();

        typeRelationResponse.description( typeRelation.getDescription() );
        typeRelationResponse.id( typeRelation.getId() );
        typeRelationResponse.libelle( typeRelation.getLibelle() );
        typeRelationResponse.ordre( typeRelation.getOrdre() );

        return typeRelationResponse.build();
    }
}
