package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Sauvegarde;
import fr.ressources.relationnelles.domain.entity.SauvegardeId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SauvegardeRepository extends JpaRepository<Sauvegarde, SauvegardeId> {

    @Query("SELECT s FROM Sauvegarde s WHERE s.utilisateur.id = :utilisateurId ORDER BY s.dateSauvegarde DESC")
    List<Sauvegarde> findByUtilisateurId(@Param("utilisateurId") Integer utilisateurId);

    boolean existsByUtilisateurIdAndRessourceId(Integer utilisateurId, Integer ressourceId);

    void deleteByUtilisateurIdAndRessourceId(Integer utilisateurId, Integer ressourceId);
}
