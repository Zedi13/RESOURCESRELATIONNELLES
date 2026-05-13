package fr.ressources.relationnelles.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CategorieResponse {
    private Integer id;
    private String nom;
    private String description;
    private String couleur;
    private String icone;
    private short ordre;
    private boolean estActive;
}
