package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import fr.ressources.relationnelles.dto.request.ModerationRessourceRequest;
import fr.ressources.relationnelles.dto.request.RessourceRequest;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.dto.response.RessourceResponse;
import fr.ressources.relationnelles.dto.response.RessourceSummaryResponse;
import fr.ressources.relationnelles.security.SecurityUtils;
import fr.ressources.relationnelles.service.RessourceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ressources")
@RequiredArgsConstructor
@Tag(name = "Ressources", description = "Catalogue de ressources relationnelles")
public class RessourceController {

    private final RessourceService ressourceService;
    private final SecurityUtils securityUtils;

    // ── Endpoints publics ──────────────────────────────────────────────────

    @GetMapping
    @Operation(summary = "Lister les ressources publiées et publiques (public)")
    public ResponseEntity<PageResponse<RessourceSummaryResponse>> listerPubliques(
        @RequestParam(required = false) Integer categorieId,
        @RequestParam(required = false) TypeRessource type,
        @RequestParam(required = false) String search,
        @PageableDefault(size = 10) Pageable pageable
    ) {
        return ResponseEntity.ok(ressourceService.listerPubliques(categorieId, type, search, pageable));
    }

    @GetMapping("/mes-ressources")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Lister les ressources accessibles par le citoyen connecté")
    public ResponseEntity<PageResponse<RessourceSummaryResponse>> listerAccessibles(
        @RequestParam(required = false) Integer categorieId,
        @RequestParam(required = false) TypeRessource type,
        @RequestParam(required = false) String search,
        @PageableDefault(size = 10) Pageable pageable
    ) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(ressourceService.listerAccessibles(utilisateur, categorieId, type, search, pageable));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Récupérer le détail d'une ressource")
    public ResponseEntity<RessourceResponse> getById(@PathVariable Integer id) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecteOuNull();
        return ResponseEntity.ok(ressourceService.getById(id, utilisateur));
    }

    // ── Endpoints citoyen connecté ─────────────────────────────────────────

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Créer une nouvelle ressource")
    public ResponseEntity<RessourceResponse> creer(@Valid @RequestBody RessourceRequest request) {
        Utilisateur auteur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.status(HttpStatus.CREATED).body(ressourceService.creer(request, auteur));
    }

    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Modifier une ressource (auteur ou admin)")
    public ResponseEntity<RessourceResponse> modifier(@PathVariable Integer id,
                                                       @Valid @RequestBody RessourceRequest request) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(ressourceService.modifier(id, request, utilisateur));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Supprimer une ressource (auteur ou admin)")
    public ResponseEntity<Void> supprimer(@PathVariable Integer id) {
        Utilisateur utilisateur = securityUtils.getUtilisateurConnecte();
        ressourceService.supprimer(id, utilisateur);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/partager")
    @Operation(summary = "Incrémenter le compteur de partages")
    public ResponseEntity<Void> partager(@PathVariable Integer id) {
        ressourceService.partager(id);
        return ResponseEntity.noContent().build();
    }

    // ── Back-office admin ──────────────────────────────────────────────────

    @GetMapping("/admin")
    @PreAuthorize("hasAnyRole('MODERATEUR', 'ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Lister toutes les ressources avec filtres (back-office)")
    public ResponseEntity<PageResponse<RessourceSummaryResponse>> listerBackOffice(
        @RequestParam(required = false) StatutRessource statut,
        @RequestParam(required = false) TypeRessource type,
        @RequestParam(required = false) Visibilite visibilite,
        @RequestParam(required = false) Integer categorieId,
        @RequestParam(required = false) Integer auteurId,
        @RequestParam(required = false) String search,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        return ResponseEntity.ok(
            ressourceService.listerBackOffice(statut, type, visibilite, categorieId, auteurId, search, pageable)
        );
    }

    @PatchMapping("/{id}/statut")
    @PreAuthorize("hasAnyRole('MODERATEUR', 'ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Changer le statut d'une ressource : publier, suspendre… (modérateur/admin)")
    public ResponseEntity<RessourceResponse> changerStatut(@PathVariable Integer id,
                                                            @Valid @RequestBody ModerationRessourceRequest request) {
        Utilisateur moderateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(ressourceService.changerStatut(id, request, moderateur));
    }
}
