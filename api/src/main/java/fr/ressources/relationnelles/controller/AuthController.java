package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.dto.request.LoginRequest;
import fr.ressources.relationnelles.dto.request.RegisterRequest;
import fr.ressources.relationnelles.dto.response.AuthResponse;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import fr.ressources.relationnelles.mapper.UtilisateurMapper;
import fr.ressources.relationnelles.security.SecurityUtils;
import fr.ressources.relationnelles.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentification", description = "Inscription, connexion et profil courant")
public class AuthController {

    private final AuthService authService;
    private final SecurityUtils securityUtils;
    private final UtilisateurMapper utilisateurMapper;

    @PostMapping("/register")
    @Operation(summary = "Créer un compte citoyen")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
    }

    @PostMapping("/login")
    @Operation(summary = "Se connecter et obtenir un token JWT")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @GetMapping("/me")
    @Operation(summary = "Récupérer le profil de l'utilisateur connecté")
    public ResponseEntity<UtilisateurResponse> me() {
        return ResponseEntity.ok(utilisateurMapper.toResponse(securityUtils.getUtilisateurConnecte()));
    }
}
