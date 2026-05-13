package fr.ressources.relationnelles.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "sauvegardes")
@IdClass(SauvegardeId.class)
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Sauvegarde {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id")
    private Utilisateur utilisateur;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ressource_id")
    private Ressource ressource;

    @Column(name = "date_sauvegarde", nullable = false)
    @Builder.Default
    private LocalDateTime dateSauvegarde = LocalDateTime.now();
}
