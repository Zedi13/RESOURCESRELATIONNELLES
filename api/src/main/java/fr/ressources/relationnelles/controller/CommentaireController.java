package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import fr.ressources.relationnelles.dto.request.CommentaireRequest;
import fr.ressources.relationnelles.dto.request.ModerationCommentaireRequest;
import fr.ressources.relationnelles.dto.response.CommentaireResponse;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.security.SecurityUtils;
import fr.ressources.relationnelles.service.CommentaireService;
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

import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Commentaires", description = "Commentaires et modération")
public class CommentaireController {

    private final CommentaireService commentaireService;
    private final SecurityUtils securityUtils;

    @GetMapping("/api/ressources/{ressourceId}/commentaires")
    @Operation(summary = "Lister les commentaires approuvés d'une ressource (public)")
    public ResponseEntity<List<CommentaireResponse>> listerApprouves(@PathVariable Integer ressourceId) {
        return ResponseEntity.ok(commentaireService.listerApprouves(ressourceId));
    }

    @PostMapping("/api/ressources/{ressourceId}/commentaires")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Poster un commentaire ou une réponse")
    public ResponseEntity<CommentaireResponse> commenter(@PathVariable Integer ressourceId,
                                                          @Valid @RequestBody CommentaireRequest request) {
        Utilisateur auteur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(commentaireService.commenter(ressourceId, request, auteur));
    }

    @DeleteMapping("/api/commentaires/{id}")
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Supprimer un commentaire (auteur ou modérateur)")
    public ResponseEntity<Void> supprimer(@PathVariable Integer id) {
        commentaireService.supprimer(id, securityUtils.getUtilisateurConnecte());
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/api/commentaires/{id}/moderer")
    @PreAuthorize("hasAnyRole('MODERATEUR', 'ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Approuver ou rejeter un commentaire (modérateur)")
    public ResponseEntity<CommentaireResponse> moderer(@PathVariable Integer id,
                                                        @Valid @RequestBody ModerationCommentaireRequest request) {
        Utilisateur moderateur = securityUtils.getUtilisateurConnecte();
        return ResponseEntity.ok(commentaireService.moderer(id, request, moderateur));
    }

    @GetMapping("/api/admin/commentaires")
    @PreAuthorize("hasAnyRole('MODERATEUR', 'ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Lister tous les commentaires avec filtres (back-office)")
    public ResponseEntity<PageResponse<CommentaireResponse>> listerBackOffice(
        @RequestParam(required = false) StatutCommentaire statut,
        @RequestParam(required = false) Integer ressourceId,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        return ResponseEntity.ok(commentaireService.listerBackOffice(statut, ressourceId, pageable));
    }
}
