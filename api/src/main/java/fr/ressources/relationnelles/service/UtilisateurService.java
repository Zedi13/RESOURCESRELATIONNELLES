package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.dto.request.CreateUserRequest;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.dto.response.UtilisateurResponse;
import fr.ressources.relationnelles.exception.BadRequestException;
import fr.ressources.relationnelles.exception.ConflictException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.mapper.UtilisateurMapper;
import fr.ressources.relationnelles.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UtilisateurService {

    private final UtilisateurRepository utilisateurRepository;
    private final UtilisateurMapper utilisateurMapper;
    private final PasswordEncoder passwordEncoder;

    public PageResponse<UtilisateurResponse> listerUtilisateurs(Role role, Boolean actif, String search, Pageable pageable) {
        return PageResponse.from(
            utilisateurRepository.findWithFilters(role, actif, search, pageable),
            utilisateurMapper::toResponse
        );
    }

    public UtilisateurResponse getById(Integer id) {
        return utilisateurMapper.toResponse(trouverOuEchouer(id));
    }

    @Transactional
    public UtilisateurResponse toggleActif(Integer id, boolean actif) {
        Utilisateur utilisateur = trouverOuEchouer(id);
        utilisateur.setEstActif(actif);
        return utilisateurMapper.toResponse(utilisateurRepository.save(utilisateur));
    }

    @Transactional
    public UtilisateurResponse creerComptePrivilegie(CreateUserRequest request) {
        if (request.role() == Role.citoyen) {
            throw new BadRequestException("Utilisez /api/auth/register pour créer un compte citoyen.");
        }
        if (utilisateurRepository.existsByEmail(request.email())) {
            throw new ConflictException("Un compte existe déjà avec cet email.");
        }

        Utilisateur utilisateur = Utilisateur.builder()
            .nomComplet(request.nomComplet())
            .email(request.email())
            .motDePasse(passwordEncoder.encode(request.motDePasse()))
            .role(request.role())
            .estVerifie(true)
            .estActif(true)
            .build();

        return utilisateurMapper.toResponse(utilisateurRepository.save(utilisateur));
    }

    public Utilisateur trouverParEmail(String email) {
        return utilisateurRepository.findByEmail(email)
            .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));
    }

    private Utilisateur trouverOuEchouer(Integer id) {
        return utilisateurRepository.findById(id)
            .orElseThrow(() -> ResourceNotFoundException.of("Utilisateur", id));
    }
}
