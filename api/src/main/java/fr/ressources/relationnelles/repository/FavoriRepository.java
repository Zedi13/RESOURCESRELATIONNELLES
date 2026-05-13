package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Favori;
import fr.ressources.relationnelles.domain.entity.FavoriId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface FavoriRepository extends JpaRepository<Favori, FavoriId> {

    @Query("SELECT f FROM Favori f WHERE f.utilisateur.id = :utilisateurId ORDER BY f.dateAjout DESC")
    List<Favori> findByUtilisateurId(@Param("utilisateurId") Integer utilisateurId);

    boolean existsByUtilisateurIdAndRessourceId(Integer utilisateurId, Integer ressourceId);

    void deleteByUtilisateurIdAndRessourceId(Integer utilisateurId, Integer ressourceId);
}
