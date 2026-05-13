package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import fr.ressources.relationnelles.dto.response.RessourceResponse;
import fr.ressources.relationnelles.dto.response.RessourceSummaryResponse;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", uses = {CategorieMapper.class, TypeRelationMapper.class})
public interface RessourceMapper {

    @Mapping(target = "auteurId", source = "auteur.id")
    @Mapping(target = "auteurNom", source = "auteur.nomComplet")
    @Mapping(target = "categorie", source = "categorie")
    @Mapping(target = "typesRelation", source = "typesRelation")
    @Mapping(target = "estFavori", ignore = true)
    @Mapping(target = "estExploite", ignore = true)
    @Mapping(target = "estSauvegarde", ignore = true)
    RessourceResponse toResponse(Ressource ressource);

    @Mapping(target = "auteurId", source = "auteur.id")
    @Mapping(target = "auteurNom", source = "auteur.nomComplet")
    @Mapping(target = "categorieId", source = "categorie.id")
    @Mapping(target = "categorieNom", source = "categorie.nom")
    @Mapping(target = "couleurCategorie", source = "categorie.couleur")
    @Mapping(target = "typesRelation", source = "typesRelation")
    RessourceSummaryResponse toSummary(Ressource ressource);

    default List<TypeRelationResponse> mapTypesRelation(Set<TypeRelation> typesRelation) {
        if (typesRelation == null) return List.of();
        return typesRelation.stream()
            .map(tr -> TypeRelationResponse.builder()
                .id(tr.getId())
                .libelle(tr.getLibelle())
                .description(tr.getDescription())
                .ordre(tr.getOrdre())
                .build())
            .collect(Collectors.toList());
    }
}
