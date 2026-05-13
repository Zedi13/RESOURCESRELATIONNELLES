package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.TypeRelation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TypeRelationRepository extends JpaRepository<TypeRelation, Integer> {

    List<TypeRelation> findAllByOrderByOrdreAsc();

    boolean existsByLibelle(String libelle);

    boolean existsByLibelleAndIdNot(String libelle, Integer id);
}
