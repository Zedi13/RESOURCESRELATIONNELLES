package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.Commentaire;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.domain.enums.StatutCommentaire;
import fr.ressources.relationnelles.dto.request.CommentaireRequest;
import fr.ressources.relationnelles.dto.request.ModerationCommentaireRequest;
import fr.ressources.relationnelles.dto.response.CommentaireResponse;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.exception.ForbiddenException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.mapper.CommentaireMapper;
import fr.ressources.relationnelles.repository.CommentaireRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommentaireService {

    private final CommentaireRepository commentaireRepository;
    private final CommentaireMapper commentaireMapper;
    private final RessourceService ressourceService;

    public List<CommentaireResponse> listerApprouves(Integer ressourceId) {
        return commentaireRepository.findApprouvesParRessource(ressourceId)
            .stream().map(commentaireMapper::toResponse).collect(Collectors.toList());
    }

    public PageResponse<CommentaireResponse> listerBackOffice(StatutCommentaire statut, Integer ressourceId, Pageable pageable) {
        return PageResponse.from(
            commentaireRepository.findBackOffice(statut, ressourceId, pageable),
            commentaireMapper::toResponse
        );
    }

    @Transactional
    public CommentaireResponse commenter(Integer ressourceId, CommentaireRequest request, Utilisateur auteur) {
        Commentaire commentaire = Commentaire.builder()
            .ressource(ressourceService.trouverOuEchouer(ressourceId))
            .auteur(auteur)
            .contenu(request.contenu())
            .statut(StatutCommentaire.en_attente)
            .build();

        if (request.parentId() != null) {
            Commentaire parent = commentaireRepository.findById(request.parentId())
                .orElseThrow(() -> ResourceNotFoundException.of("Commentaire parent", request.parentId()));
            commentaire.setParent(parent);
        }

        return commentaireMapper.toResponse(commentaireRepository.save(commentaire));
    }

    @Transactional
    public CommentaireResponse moderer(Integer id, ModerationCommentaireRequest request, Utilisateur moderateur) {
        Commentaire commentaire = trouverOuEchouer(id);
        commentaire.setStatut(request.decision());
        commentaire.setModerateur(moderateur);
        commentaire.setDateModeration(LocalDateTime.now());
        return commentaireMapper.toResponse(commentaireRepository.save(commentaire));
    }

    @Transactional
    public void supprimer(Integer id, Utilisateur utilisateur) {
        Commentaire commentaire = trouverOuEchouer(id);
        boolean estAuteur = commentaire.getAuteur().getId().equals(utilisateur.getId());
        boolean estAdmin = utilisateur.getRole() == Role.admin || utilisateur.getRole() == Role.super_admin
                        || utilisateur.getRole() == Role.moderateur;
        if (!estAuteur && !estAdmin) {
            throw new ForbiddenException("Vous ne pouvez pas supprimer ce commentaire.");
        }
        commentaireRepository.delete(commentaire);
    }

    private Commentaire trouverOuEchouer(Integer id) {
        return commentaireRepository.findById(id)
            .orElseThrow(() -> ResourceNotFoundException.of("Commentaire", id));
    }
}
