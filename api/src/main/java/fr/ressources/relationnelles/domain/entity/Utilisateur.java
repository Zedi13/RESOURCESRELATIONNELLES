package fr.ressources.relationnelles.domain.entity;

import fr.ressources.relationnelles.domain.enums.Role;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "utilisateurs")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "nom_complet", nullable = false, length = 100)
    private String nomComplet;

    @Column(nullable = false, length = 150, unique = true)
    private String email;

    @Column(name = "mot_de_passe", nullable = false, length = 255)
    private String motDePasse;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Role role = Role.citoyen;

    @Column(name = "est_verifie", nullable = false)
    @Builder.Default
    private boolean estVerifie = false;

    @Column(name = "est_actif", nullable = false)
    @Builder.Default
    private boolean estActif = true;

    @Column(name = "derniere_connexion")
    private LocalDateTime derniereConnexion;

    @Column(name = "date_inscription", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime dateInscription = LocalDateTime.now();

    @OneToMany(mappedBy = "auteur", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Ressource> ressources = new ArrayList<>();

    @OneToMany(mappedBy = "auteur", fetch = FetchType.LAZY)
    @Builder.Default
    private List<Commentaire> commentaires = new ArrayList<>();

    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Favori> favoris = new ArrayList<>();

    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Exploitation> exploitations = new ArrayList<>();

    @OneToMany(mappedBy = "utilisateur", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Sauvegarde> sauvegardes = new ArrayList<>();
}
