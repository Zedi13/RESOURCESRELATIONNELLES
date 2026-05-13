package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.dto.request.LoginRequest;
import fr.ressources.relationnelles.dto.request.RegisterRequest;
import fr.ressources.relationnelles.dto.response.AuthResponse;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import fr.ressources.relationnelles.exception.ConflictException;
import fr.ressources.relationnelles.mapper.UtilisateurMapper;
import fr.ressources.relationnelles.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UtilisateurMapper utilisateurMapper;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (utilisateurRepository.existsByEmail(request.email())) {
            throw new ConflictException("Un compte existe déjà avec cet email.");
        }

        Utilisateur utilisateur = Utilisateur.builder()
            .nomComplet(request.nomComplet())
            .email(request.email())
            .motDePasse(passwordEncoder.encode(request.motDePasse()))
            .role(Role.citoyen)
            .estVerifie(false)
            .estActif(true)
            .build();

        utilisateur = utilisateurRepository.save(utilisateur);

        String token = genererToken(utilisateur);
        return AuthResponse.of(token, utilisateurMapper.toResponse(utilisateur));
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.email(), request.motDePasse())
        );

        Utilisateur utilisateur = utilisateurRepository.findByEmail(request.email()).orElseThrow();
        utilisateur.setDerniereConnexion(LocalDateTime.now());
        utilisateurRepository.save(utilisateur);

        String token = genererToken(utilisateur);
        return AuthResponse.of(token, utilisateurMapper.toResponse(utilisateur));
    }

    private String genererToken(Utilisateur utilisateur) {
        return jwtService.genererToken(
            org.springframework.security.core.userdetails.User.builder()
                .username(utilisateur.getEmail())
                .password(utilisateur.getMotDePasse())
                .authorities("ROLE_" + utilisateur.getRole().name().toUpperCase())
                .build(),
            Map.of(
                "id", utilisateur.getId(),
                "role", utilisateur.getRole().name(),
                "nomComplet", utilisateur.getNomComplet()
            )
        );
    }
}
