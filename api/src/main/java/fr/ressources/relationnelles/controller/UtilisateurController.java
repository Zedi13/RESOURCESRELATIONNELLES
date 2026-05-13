package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.dto.request.CreateUserRequest;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import fr.ressources.relationnelles.service.UtilisateurService;
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
@RequestMapping("/api/utilisateurs")
@RequiredArgsConstructor
@Tag(name = "Utilisateurs", description = "Gestion des comptes utilisateurs")
public class UtilisateurController {

    private final UtilisateurService utilisateurService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Lister tous les utilisateurs (admin)")
    public ResponseEntity<PageResponse<UtilisateurResponse>> lister(
        @RequestParam(required = false) Role role,
        @RequestParam(required = false) Boolean actif,
        @RequestParam(required = false) String search,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        return ResponseEntity.ok(utilisateurService.listerUtilisateurs(role, actif, search, pageable));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Récupérer un utilisateur par id (admin)")
    public ResponseEntity<UtilisateurResponse> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(utilisateurService.getById(id));
    }

    @PatchMapping("/{id}/activer")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Activer un compte citoyen (admin)")
    public ResponseEntity<UtilisateurResponse> activer(@PathVariable Integer id) {
        return ResponseEntity.ok(utilisateurService.toggleActif(id, true));
    }

    @PatchMapping("/{id}/desactiver")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Désactiver un compte citoyen (admin)")
    public ResponseEntity<UtilisateurResponse> desactiver(@PathVariable Integer id) {
        return ResponseEntity.ok(utilisateurService.toggleActif(id, false));
    }

    @PostMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @Operation(summary = "Créer un compte modérateur / admin / super-admin (super-admin uniquement)")
    public ResponseEntity<UtilisateurResponse> creerComptePrivilegie(@Valid @RequestBody CreateUserRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(utilisateurService.creerComptePrivilegie(request));
    }
}
