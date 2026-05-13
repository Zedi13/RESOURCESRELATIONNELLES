package fr.ressources.relationnelles.mapper;

import fr.ressources.relationnelles.domain.entity.Commentaire;
import fr.ressources.relationnelles.dto.response.CommentaireResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring")
public interface CommentaireMapper {

    @Mapping(target = "ressourceId", source = "ressource.id")
    @Mapping(target = "auteurId", source = "auteur.id")
    @Mapping(target = "auteurNom", source = "auteur.nomComplet")
    @Mapping(target = "parentId", source = "parent.id")
    @Mapping(target = "reponses", expression = "java(mapReponses(commentaire))")
    CommentaireResponse toResponse(Commentaire commentaire);

    // Une seule profondeur de réponses pour éviter la récursion infinie
    default List<CommentaireResponse> mapReponses(Commentaire commentaire) {
        if (commentaire.getReponses() == null) return List.of();
        return commentaire.getReponses().stream()
            .filter(r -> r.getStatut().name().equals("approuve"))
            .map(r -> CommentaireResponse.builder()
                .id(r.getId())
                .ressourceId(r.getRessource().getId())
                .auteurId(r.getAuteur().getId())
                .auteurNom(r.getAuteur().getNomComplet())
                .contenu(r.getContenu())
                .statut(r.getStatut())
                .parentId(commentaire.getId())
                .dateCreation(r.getDateCreation())
                .reponses(List.of())
                .build())
            .collect(Collectors.toList());
    }
}
