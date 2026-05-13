package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.dto.request.CategorieRequest;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import fr.ressources.relationnelles.service.CategorieService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
@Tag(name = "Catégories", description = "Catalogue des catégories de ressources")
public class CategorieController {

    private final CategorieService categorieService;

    @GetMapping
    @Operation(summary = "Lister les catégories actives (public)")
    public ResponseEntity<List<CategorieResponse>> lister() {
        return ResponseEntity.ok(categorieService.listerActives());
    }

    @GetMapping("/toutes")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Lister toutes les catégories y compris inactives (admin)")
    public ResponseEntity<List<CategorieResponse>> listerToutes() {
        return ResponseEntity.ok(categorieService.listerToutes());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Récupérer une catégorie par id (public)")
    public ResponseEntity<CategorieResponse> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(categorieService.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Créer une catégorie (admin)")
    public ResponseEntity<CategorieResponse> creer(@Valid @RequestBody CategorieRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(categorieService.creer(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Modifier une catégorie (admin)")
    public ResponseEntity<CategorieResponse> modifier(@PathVariable Integer id,
                                                       @Valid @RequestBody CategorieRequest request) {
        return ResponseEntity.ok(categorieService.modifier(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Supprimer ou désactiver une catégorie (admin)")
    public ResponseEntity<Void> supprimer(@PathVariable Integer id) {
        categorieService.supprimer(id);
        return ResponseEntity.noContent().build();
    }
}
