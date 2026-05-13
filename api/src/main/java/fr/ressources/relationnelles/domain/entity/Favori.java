package fr.ressources.relationnelles.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "favoris")
@IdClass(FavoriId.class)
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Favori {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id")
    private Utilisateur utilisateur;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ressource_id")
    private Ressource ressource;

    @Column(name = "date_ajout", nullable = false)
    @Builder.Default
    private LocalDateTime dateAjout = LocalDateTime.now();
}
