package fr.ressources.relationnelles.domain.entity;

import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "ressources")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Ressource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String titre;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String contenu;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private TypeRessource type = TypeRessource.article;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Visibilite visibilite = Visibilite.publique;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private StatutRessource statut = StatutRessource.brouillon;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "auteur_id", nullable = false)
    private Utilisateur auteur;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "categorie_id", nullable = false)
    private Categorie categorie;

    @Column(name = "url_externe", length = 500)
    private String urlExterne;

    @Column(name = "duree_estimee_min", nullable = false, columnDefinition = "SMALLINT")
    @Builder.Default
    private int dureeEstimeeMin = 0;

    @Column(nullable = false)
    @Builder.Default
    private int vues = 0;

    @Column(nullable = false)
    @Builder.Default
    private int partages = 0;

    @Column(name = "date_creation", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime dateCreation = LocalDateTime.now();

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @Column(name = "date_publication")
    private LocalDateTime datePublication;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "ressource_type_relation",
        joinColumns = @JoinColumn(name = "ressource_id"),
        inverseJoinColumns = @JoinColumn(name = "type_relation_id")
    )
    @Builder.Default
    private Set<TypeRelation> typesRelation = new HashSet<>();

    @OneToMany(mappedBy = "ressource", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Commentaire> commentaires = new ArrayList<>();

    @PreUpdate
    public void onUpdate() {
        this.dateModification = LocalDateTime.now();
    }
}
