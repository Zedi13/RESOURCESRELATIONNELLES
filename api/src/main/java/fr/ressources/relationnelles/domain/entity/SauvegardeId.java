package fr.ressources.relationnelles.domain.entity;

import lombok.*;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class SauvegardeId implements Serializable {
    private Integer utilisateur;
    private Integer ressource;
}
