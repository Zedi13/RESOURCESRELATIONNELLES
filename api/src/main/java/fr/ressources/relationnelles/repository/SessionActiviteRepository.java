package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.SessionActivite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SessionActiviteRepository extends JpaRepository<SessionActivite, Integer> {

    Optional<SessionActivite> findByCode(String code);

    boolean existsByCode(String code);
}
