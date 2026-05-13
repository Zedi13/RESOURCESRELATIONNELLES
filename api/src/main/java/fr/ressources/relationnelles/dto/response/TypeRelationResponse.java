package fr.ressources.relationnelles.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TypeRelationResponse {
    private Integer id;
    private String libelle;
    private String description;
    private short ordre;
}
