package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Commentaire;
import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CommentaireRepository extends JpaRepository<Commentaire, Integer> {

    // Commentaires racines approuvés d'une ressource (avec leurs réponses)
    @Query("SELECT c FROM Commentaire c WHERE c.ressource.id = :ressourceId " +
           "AND c.parent IS NULL AND c.statut = 'approuve' ORDER BY c.dateCreation ASC")
    List<Commentaire> findApprouvesParRessource(@Param("ressourceId") Integer ressourceId);

    // Back-office : tous les commentaires avec filtres
    @Query("SELECT c FROM Commentaire c WHERE " +
           "(:statut IS NULL OR c.statut = :statut) AND " +
           "(:ressourceId IS NULL OR c.ressource.id = :ressourceId)")
    Page<Commentaire> findBackOffice(@Param("statut") StatutCommentaire statut,
                                     @Param("ressourceId") Integer ressourceId,
                                     Pageable pageable);

    long countByStatut(StatutCommentaire statut);
}
