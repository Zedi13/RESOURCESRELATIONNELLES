package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface TypeRelationMapper {

    TypeRelationResponse toResponse(TypeRelation typeRelation);
}
