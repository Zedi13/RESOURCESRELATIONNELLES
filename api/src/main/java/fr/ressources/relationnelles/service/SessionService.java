package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.MessageSession;
import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.SessionActivite;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.StatutSession;
import fr.ressources.relationnelles.dto.request.CreateSessionRequest;
import fr.ressources.relationnelles.dto.request.MessageSessionRequest;
import fr.ressources.relationnelles.dto.response.SessionResponse;
import fr.ressources.relationnelles.exception.BadRequestException;
import fr.ressources.relationnelles.exception.ForbiddenException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.repository.MessageSessionRepository;
import fr.ressources.relationnelles.repository.RessourceRepository;
import fr.ressources.relationnelles.repository.SessionActiviteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class SessionService {

    private static final String CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CODE_LENGTH = 6;
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    private final SessionActiviteRepository sessionRepository;
    private final MessageSessionRepository messageRepository;
    private final RessourceRepository ressourceRepository;

    // ── Créer une session ──────────────────────────────────────────────────────

    public SessionResponse creerSession(CreateSessionRequest request, Utilisateur createur) {
        Ressource ressource = ressourceRepository.findById(request.ressourceId())
                .orElseThrow(() -> ResourceNotFoundException.of("Ressource", request.ressourceId()));

        String code = genererCode();

        SessionActivite session = SessionActivite.builder()
                .code(code)
                .ressource(ressource)
                .createur(createur)
                .statut(StatutSession.ACTIVE)
                .build();

        // Le créateur est automatiquement participant
        session.getParticipants().add(createur);

        return toResponse(sessionRepository.save(session));
    }

    // ── Obtenir une session ────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public SessionResponse getSession(String code) {
        SessionActivite session = sessionRepository.findByCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Session introuvable avec le code : " + code));
        return toResponse(session);
    }

    // ── Rejoindre une session ──────────────────────────────────────────────────

    public SessionResponse rejoindreSession(String code, Utilisateur utilisateur) {
        SessionActivite session = sessionRepository.findByCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Session introuvable avec le code : " + code));

        if (session.getStatut() != StatutSession.ACTIVE) {
            throw new BadRequestException("Cette session est terminée");
        }

        session.getParticipants().add(utilisateur);
        return toResponse(sessionRepository.save(session));
    }

    // ── Envoyer un message ─────────────────────────────────────────────────────

    public SessionResponse envoyerMessage(String code, MessageSessionRequest request, Utilisateur auteur) {
        SessionActivite session = sessionRepository.findByCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Session introuvable avec le code : " + code));

        if (session.getStatut() != StatutSession.ACTIVE) {
            throw new BadRequestException("Impossible d'envoyer un message : la session est terminée");
        }

        // Vérifier que l'utilisateur est bien participant
        boolean estParticipant = session.getParticipants().stream()
                .anyMatch(p -> p.getId().equals(auteur.getId()));
        if (!estParticipant) {
            throw new ForbiddenException("Vous n'êtes pas participant de cette session");
        }

        MessageSession message = MessageSession.builder()
                .session(session)
                .auteur(auteur)
                .contenu(request.contenu())
                .build();

        messageRepository.save(message);
        session.getMessages().add(message);

        return toResponse(session);
    }

    // ── Terminer une session ───────────────────────────────────────────────────

    public void terminerSession(String code, Utilisateur utilisateur) {
        SessionActivite session = sessionRepository.findByCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Session introuvable avec le code : " + code));

        if (!session.getCreateur().getId().equals(utilisateur.getId())) {
            throw new ForbiddenException("Seul le créateur peut terminer la session");
        }

        session.setStatut(StatutSession.TERMINEE);
        sessionRepository.save(session);
    }

    // ── Utilitaires ───────────────────────────────────────────────────────────

    private String genererCode() {
        SecureRandom random = new SecureRandom();
        String code;
        do {
            StringBuilder sb = new StringBuilder(CODE_LENGTH);
            for (int i = 0; i < CODE_LENGTH; i++) {
                sb.append(CODE_CHARS.charAt(random.nextInt(CODE_CHARS.length())));
            }
            code = sb.toString();
        } while (sessionRepository.existsByCode(code));
        return code;
    }

    private SessionResponse toResponse(SessionActivite session) {
        List<SessionResponse.ParticipantInfo> participants = session.getParticipants().stream()
                .map(p -> new SessionResponse.ParticipantInfo(p.getId(), p.getNomComplet()))
                .collect(Collectors.toList());

        List<SessionResponse.MessageInfo> messages = session.getMessages().stream()
                .map(m -> new SessionResponse.MessageInfo(
                        m.getId(),
                        m.getAuteur().getId(),
                        m.getAuteur().getNomComplet(),
                        m.getContenu(),
                        m.getDateEnvoi().format(FORMATTER)
                ))
                .collect(Collectors.toList());

        return new SessionResponse(
                session.getId(),
                session.getCode(),
                session.getRessource().getId(),
                session.getRessource().getTitre(),
                session.getCreateur().getId(),
                session.getCreateur().getNomComplet(),
                session.getStatut().name(),
                session.getDateCreation().format(FORMATTER),
                participants,
                messages
        );
    }
}
