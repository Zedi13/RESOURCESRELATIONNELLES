package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UtilisateurMapper {

    UtilisateurResponse toResponse(Utilisateur utilisateur);
}
