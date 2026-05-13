package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CategorieMapper {

    CategorieResponse toResponse(Categorie categorie);
}
