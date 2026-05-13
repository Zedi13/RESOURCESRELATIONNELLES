package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UtilisateurRepository extends JpaRepository<Utilisateur, Integer> {

    Optional<Utilisateur> findByEmail(String email);

    boolean existsByEmail(String email);

    @Query("SELECT u FROM Utilisateur u WHERE " +
           "(:role IS NULL OR u.role = :role) AND " +
           "(:actif IS NULL OR u.estActif = :actif) AND " +
           "(:search IS NULL OR LOWER(u.nomComplet) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "   OR LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Utilisateur> findWithFilters(@Param("role") Role role,
                                     @Param("actif") Boolean actif,
                                     @Param("search") String search,
                                     Pageable pageable);

    long countByRole(Role role);

    long countByEstActifTrue();
}
