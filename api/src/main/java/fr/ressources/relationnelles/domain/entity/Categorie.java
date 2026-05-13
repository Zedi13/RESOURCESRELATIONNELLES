package fr.ressources.relationnelles.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categories")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Categorie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100, unique = true)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 7)
    @Builder.Default
    private String couleur = "#2E86AB";

    @Column(nullable = false, length = 50)
    @Builder.Default
    private String icone = "category";

    @Column(nullable = false)
    @Builder.Default
    private short ordre = 0;

    @Column(name = "est_active", nullable = false)
    @Builder.Default
    private boolean estActive = true;

    @Column(name = "date_creation", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime dateCreation = LocalDateTime.now();

    @OneToMany(mappedBy = "categorie", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Ressource> ressources = new ArrayList<>();
}
