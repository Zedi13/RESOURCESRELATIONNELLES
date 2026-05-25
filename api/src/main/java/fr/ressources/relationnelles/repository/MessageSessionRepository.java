package fr.ressources.relationnelles.repository;

import fr.ressources.relationnelles.domain.entity.MessageSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageSessionRepository extends JpaRepository<MessageSession, Integer> {
}
