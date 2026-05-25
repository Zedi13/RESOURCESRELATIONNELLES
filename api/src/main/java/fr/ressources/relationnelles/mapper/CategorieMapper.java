package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CategorieMapper {

    @Mapping(target = "nombreRessources", expression = "java(categorie.getRessources().size())")
    CategorieResponse toResponse(Categorie categorie);
}
