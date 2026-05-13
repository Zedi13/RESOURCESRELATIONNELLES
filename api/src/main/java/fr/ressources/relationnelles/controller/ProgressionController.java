package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.dto.response.ProgressionResponse;
import fr.ressources.relationnelles.security.SecurityUtils;
import fr.ressources.relationnelles.service.ProgressionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/progression")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
@Tag(name = "Progression", description = "Favoris, ressources exploitées et sauvegardées")
public class ProgressionController {

    private final ProgressionService progressionService;
    private final SecurityUtils securityUtils;

    @GetMapping
    @Operation(summary = "Tableau de bord de progression de l'utilisateur connecté")
    public ResponseEntity<ProgressionResponse> getDashboard() {
        return ResponseEntity.ok(progressionService.getProgression(securityUtils.getUtilisateurConnecte()));
    }

    // ── Favoris ──────────────────────────────────────────────────────────

    @PostMapping("/favoris/{ressourceId}")
    @Operation(summary = "Ajouter une ressource aux favoris")
    public ResponseEntity<Void> ajouterFavori(@PathVariable Integer ressourceId) {
        progressionService.ajouterFavori(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/favoris/{ressourceId}")
    @Operation(summary = "Retirer une ressource des favoris")
    public ResponseEntity<Void> retirerFavori(@PathVariable Integer ressourceId) {
        progressionService.retirerFavori(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    // ── Exploitations ─────────────────────────────────────────────────────

    @PostMapping("/exploitations/{ressourceId}")
    @Operation(summary = "Marquer une ressource comme exploitée (terminée)")
    public ResponseEntity<Void> marquerExploitee(@PathVariable Integer ressourceId) {
        progressionService.marquerExploitee(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/exploitations/{ressourceId}")
    @Operation(summary = "Retirer le marquage exploitée")
    public ResponseEntity<Void> demarquerExploitee(@PathVariable Integer ressourceId) {
        progressionService.demarquerExploitee(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    // ── Sauvegardes ───────────────────────────────────────────────────────

    @PostMapping("/sauvegardes/{ressourceId}")
    @Operation(summary = "Mettre de côté une ressource pour plus tard")
    public ResponseEntity<Void> sauvegarder(@PathVariable Integer ressourceId) {
        progressionService.sauvegarder(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/sauvegardes/{ressourceId}")
    @Operation(summary = "Retirer une ressource de la liste 'pour plus tard'")
    public ResponseEntity<Void> retirerSauvegarde(@PathVariable Integer ressourceId) {
        progressionService.retirerSauvegarde(ressourceId, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }
}
