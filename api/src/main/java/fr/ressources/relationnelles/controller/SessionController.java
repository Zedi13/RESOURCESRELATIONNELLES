package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.request.CreateSessionRequest;
import fr.ressources.relationnelles.dto.request.MessageSessionRequest;
import fr.ressources.relationnelles.dto.response.SessionResponse;
import fr.ressources.relationnelles.security.SecurityUtils;
import fr.ressources.relationnelles.service.SessionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sessions")
@RequiredArgsConstructor
@Tag(name = "Sessions", description = "Sessions collaboratives pour activités et jeux")
public class SessionController {

    private final SessionService sessionService;
    private final SecurityUtils securityUtils;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Créer une nouvelle session collaborative")
    public ResponseEntity<SessionResponse> creerSession(
            @Valid @RequestBody CreateSessionRequest request
    ) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(sessionService.creerSession(request, utilisateur));
    }

    @GetMapping("/{code}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Obtenir les détails d'une session par son code")
    public ResponseEntity<SessionResponse> getSession(@PathVariable String code) {
        return ResponseEntity.ok(sessionService.getSession(code));
    }

    @PostMapping("/{code}/rejoindre")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Rejoindre une session existante")
    public ResponseEntity<SessionResponse> rejoindreSession(@PathVariable String code) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(sessionService.rejoindreSession(code, utilisateur));
    }

    @PostMapping("/{code}/messages")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Envoyer un message dans une session")
    public ResponseEntity<SessionResponse> envoyerMessage(
            @PathVariable String code,
            @Valid @RequestBody MessageSessionRequest request
    ) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(sessionService.envoyerMessage(code, request, utilisateur));
    }

    @DeleteMapping("/{code}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Terminer une session (créateur uniquement)")
    public ResponseEntity<Void> terminerSession(@PathVariable String code) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        sessionService.terminerSession(code, utilisateur);
        return ResponseEntity.noContent().build();
    }
}
