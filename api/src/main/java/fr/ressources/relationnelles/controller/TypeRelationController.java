package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.dto.request.TypeRelationRequest;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import fr.ressources.relationnelles.service.TypeRelationService;
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
@RequestMapping("/api/types-relation")
@RequiredArgsConstructor
@Tag(name = "Types de relation", description = "Couple, Famille, Amis…")
public class TypeRelationController {

    private final TypeRelationService typeRelationService;

    @GetMapping
    @Operation(summary = "Lister tous les types de relation (public)")
    public ResponseEntity<List<TypeRelationResponse>> lister() {
        return ResponseEntity.ok(typeRelationService.listerTous());
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Créer un type de relation (admin)")
    public ResponseEntity<TypeRelationResponse> creer(@Valid @RequestBody TypeRelationRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(typeRelationService.creer(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Modifier un type de relation (admin)")
    public ResponseEntity<TypeRelationResponse> modifier(@PathVariable Integer id,
                                                          @Valid @RequestBody TypeRelationRequest request) {
        return ResponseEntity.ok(typeRelationService.modifier(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Supprimer un type de relation (admin)")
    public ResponseEntity<Void> supprimer(@PathVariable Integer id) {
        typeRelationService.supprimer(id);
        return ResponseEntity.noContent().build();
    }
}
