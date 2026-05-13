package fr.ressources.relationnelles.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "types_relation")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class TypeRelation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50, unique = true)
    private String libelle;

    @Column(length = 255)
    private String description;

    @Column(nullable = false)
    @Builder.Default
    private short ordre = 0;
}
