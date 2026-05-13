package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Categorie;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategorieRepository extends JpaRepository<Categorie, Integer> {

    List<Categorie> findByEstActiveTrueOrderByOrdreAsc();

    boolean existsByNom(String nom);

    boolean existsByNomAndIdNot(String nom, Integer id);
}
