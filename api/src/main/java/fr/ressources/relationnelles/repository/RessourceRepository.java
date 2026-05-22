package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface RessourceRepository extends JpaRepository<Ressource, Integer> {

    // Endpoint public : ressources publiées et publiques avec filtres optionnels
    @Query("SELECT r FROM Ressource r WHERE r.statut = 'publie' AND r.visibilite = 'publique' AND " +
           "(:categorieId IS NULL OR r.categorie.id = :categorieId) AND " +
           "(:type IS NULL OR r.type = :type) AND " +
           "(:search IS NULL OR LOWER(r.titre) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "   OR LOWER(r.description) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Ressource> findPubliques(@Param("categorieId") Integer categorieId,
                                  @Param("type") TypeRessource type,
                                  @Param("search") String search,
                                  Pageable pageable);

    // Endpoint citoyen connecté : ses propres ressources + ressources publiques/partagées
    @Query("SELECT r FROM Ressource r WHERE " +
           "(r.statut = 'publie' AND r.visibilite IN ('publique', 'partagee')) OR " +
           "(r.auteur.id = :auteurId) AND " +
           "(:categorieId IS NULL OR r.categorie.id = :categorieId) AND " +
           "(:type IS NULL OR r.type = :type) AND " +
           "(:search IS NULL OR LOWER(r.titre) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Ressource> findAccessibles(@Param("auteurId") Integer auteurId,
                                    @Param("categorieId") Integer categorieId,
                                    @Param("type") TypeRessource type,
                                    @Param("search") String search,
                                    Pageable pageable);

    // Back-office admin : toutes ressources avec filtres
    @Query("SELECT r FROM Ressource r WHERE " +
           "(:statut IS NULL OR r.statut = :statut) AND " +
           "(:type IS NULL OR r.type = :type) AND " +
           "(:visibilite IS NULL OR r.visibilite = :visibilite) AND " +
           "(:categorieId IS NULL OR r.categorie.id = :categorieId) AND " +
           "(:auteurId IS NULL OR r.auteur.id = :auteurId) AND " +
           "(:search IS NULL OR LOWER(r.titre) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Ressource> findBackOffice(@Param("statut") StatutRessource statut,
                                   @Param("type") TypeRessource type,
                                   @Param("visibilite") Visibilite visibilite,
                                   @Param("categorieId") Integer categorieId,
                                   @Param("auteurId") Integer auteurId,
                                   @Param("search") String search,
                                   Pageable pageable);

    @Modifying
    @Query("UPDATE Ressource r SET r.vues = r.vues + 1 WHERE r.id = :id")
    void incrementerVues(@Param("id") Integer id);

    @Modifying
    @Query("UPDATE Ressource r SET r.partages = r.partages + 1 WHERE r.id = :id")
    void incrementerPartages(@Param("id") Integer id);

    // Mes créations : toutes les ressources dont l'auteur est l'utilisateur connecté
    Page<Ressource> findByAuteurIdOrderByDateCreationDesc(Integer auteurId, Pageable pageable);

    // Statistiques
    long countByStatut(StatutRessource statut);

    @Query("SELECT r.type, COUNT(r) FROM Ressource r GROUP BY r.type")
    List<Object[]> countParType();

    @Query("SELECT r.categorie.nom, COUNT(r) FROM Ressource r GROUP BY r.categorie.nom")
    List<Object[]> countParCategorie();

    @Query("SELECT COALESCE(SUM(r.vues), 0) FROM Ressource r")
    long sumVues();

    @Query("SELECT COALESCE(SUM(r.partages), 0) FROM Ressource r")
    long sumPartages();

    @Query("SELECT YEAR(r.dateCreation), MONTH(r.dateCreation), COUNT(r), COALESCE(SUM(r.vues), 0) " +
           "FROM Ressource r GROUP BY YEAR(r.dateCreation), MONTH(r.dateCreation) " +
           "ORDER BY YEAR(r.dateCreation) DESC, MONTH(r.dateCreation) DESC")
    List<Object[]> statsParMois();
}
