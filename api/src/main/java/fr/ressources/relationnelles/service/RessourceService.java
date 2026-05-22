package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.Ressource;
import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.domain.enums.StatutRessource;
import fr.ressources.relationnelles.domain.enums.TypeRessource;
import fr.ressources.relationnelles.domain.enums.Visibilite;
import fr.ressources.relationnelles.dto.request.ModerationRessourceRequest;
import fr.ressources.relationnelles.dto.request.RessourceRequest;
import fr.ressources.relationnelles.dto.response.PageResponse;
import fr.ressources.relationnelles.dto.response.RessourceResponse;
import fr.ressources.relationnelles.dto.response.RessourceSummaryResponse;
import fr.ressources.relationnelles.exception.ForbiddenException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.mapper.RessourceMapper;
import fr.ressources.relationnelles.repository.ExploitationRepository;
import fr.ressources.relationnelles.repository.FavoriRepository;
import fr.ressources.relationnelles.repository.RessourceRepository;
import fr.ressources.relationnelles.repository.SauvegardeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RessourceService {

    private final RessourceRepository ressourceRepository;
    private final RessourceMapper ressourceMapper;
    private final CategorieService categorieService;
    private final TypeRelationService typeRelationService;
    private final FavoriRepository favoriRepository;
    private final ExploitationRepository exploitationRepository;
    private final SauvegardeRepository sauvegardeRepository;

    public PageResponse<RessourceSummaryResponse> listerPubliques(Integer categorieId, TypeRessource type,
                                                                   String search, Pageable pageable) {
        return PageResponse.from(
            ressourceRepository.findPubliques(categorieId, type, search, pageable),
            ressourceMapper::toSummary
        );
    }

    public PageResponse<RessourceSummaryResponse> listerAccessibles(Utilisateur utilisateur, Integer categorieId,
                                                                      TypeRessource type, String search, Pageable pageable) {
        return PageResponse.from(
            ressourceRepository.findAccessibles(utilisateur.getId(), categorieId, type, search, pageable),
            ressourceMapper::toSummary
        );
    }

    public PageResponse<RessourceSummaryResponse> listerBackOffice(StatutRessource statut, TypeRessource type,
                                                                    Visibilite visibilite, Integer categorieId,
                                                                    Integer auteurId, String search, Pageable pageable) {
        return PageResponse.from(
            ressourceRepository.findBackOffice(statut, type, visibilite, categorieId, auteurId, search, pageable),
            ressourceMapper::toSummary
        );
    }

    public PageResponse<RessourceSummaryResponse> listerMesCreations(Utilisateur auteur, Pageable pageable) {
        return PageResponse.from(
            ressourceRepository.findByAuteurIdOrderByDateCreationDesc(auteur.getId(), pageable),
            ressourceMapper::toSummary
        );
    }

    @Transactional
    public RessourceResponse getById(Integer id, Utilisateur utilisateur) {
        Ressource ressource = trouverOuEchouer(id);

        // Vérification accès
        boolean estAuteur = utilisateur != null && ressource.getAuteur().getId().equals(utilisateur.getId());
        boolean estAdmin = utilisateur != null && (utilisateur.getRole() == Role.admin || utilisateur.getRole() == Role.super_admin);
        boolean estPublique = ressource.getVisibilite() == Visibilite.publique && ressource.getStatut() == StatutRessource.publie;
        boolean estPartagee = ressource.getVisibilite() == Visibilite.partagee && ressource.getStatut() == StatutRessource.publie && utilisateur != null;

        if (!estPublique && !estPartagee && !estAuteur && !estAdmin) {
            throw new ForbiddenException("Vous n'avez pas accès à cette ressource.");
        }

        // Incrémenter les vues (sauf pour l'auteur/admin)
        if (!estAuteur && !estAdmin) {
            ressourceRepository.incrementerVues(id);
        }

        RessourceResponse response = ressourceMapper.toResponse(ressource);

        // Enrichissement avec l'état de progression du citoyen connecté
        if (utilisateur != null) {
            response.setEstFavori(favoriRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), id));
            response.setEstExploite(exploitationRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), id));
            response.setEstSauvegarde(sauvegardeRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), id));
        }

        return response;
    }

    @Transactional
    public RessourceResponse creer(RessourceRequest request, Utilisateur auteur) {
        List<TypeRelation> typesRelation = request.typesRelationIds().stream()
            .map(typeRelationService::trouverOuEchouer)
            .toList();

        Ressource ressource = Ressource.builder()
            .titre(request.titre())
            .description(request.description())
            .contenu(request.contenu())
            .type(request.type())
            .visibilite(request.visibilite())
            .statut(StatutRessource.en_attente) // Toujours en attente de validation
            .auteur(auteur)
            .categorie(categorieService.trouverOuEchouer(request.categorieId()))
            .urlExterne(request.urlExterne())
            .dureeEstimeeMin(request.dureeEstimeeMin())
            .typesRelation(new HashSet<>(typesRelation))
            .build();

        // Les admins publient directement
        if (auteur.getRole() == Role.admin || auteur.getRole() == Role.super_admin) {
            ressource.setStatut(StatutRessource.publie);
            ressource.setDatePublication(LocalDateTime.now());
        }

        return ressourceMapper.toResponse(ressourceRepository.save(ressource));
    }

    @Transactional
    public RessourceResponse modifier(Integer id, RessourceRequest request, Utilisateur utilisateur) {
        Ressource ressource = trouverOuEchouer(id);
        verifierDroitsModification(ressource, utilisateur);

        List<TypeRelation> typesRelation = request.typesRelationIds().stream()
            .map(typeRelationService::trouverOuEchouer)
            .toList();

        ressource.setTitre(request.titre());
        ressource.setDescription(request.description());
        ressource.setContenu(request.contenu());
        ressource.setType(request.type());
        ressource.setVisibilite(request.visibilite());
        ressource.setCategorie(categorieService.trouverOuEchouer(request.categorieId()));
        ressource.setUrlExterne(request.urlExterne());
        ressource.setDureeEstimeeMin(request.dureeEstimeeMin());
        ressource.setTypesRelation(new HashSet<>(typesRelation));

        // Repasse en attente si modifié par un citoyen
        if (utilisateur.getRole() == Role.citoyen) {
            ressource.setStatut(StatutRessource.en_attente);
        }

        return ressourceMapper.toResponse(ressourceRepository.save(ressource));
    }

    @Transactional
    public RessourceResponse changerStatut(Integer id, ModerationRessourceRequest request, Utilisateur moderateur) {
        Ressource ressource = trouverOuEchouer(id);
        ressource.setStatut(request.statut());
        if (request.statut() == StatutRessource.publie) {
            ressource.setDatePublication(LocalDateTime.now());
        }
        return ressourceMapper.toResponse(ressourceRepository.save(ressource));
    }

    @Transactional
    public void supprimer(Integer id, Utilisateur utilisateur) {
        Ressource ressource = trouverOuEchouer(id);
        verifierDroitsModification(ressource, utilisateur);
        ressourceRepository.delete(ressource);
    }

    @Transactional
    public void partager(Integer id) {
        trouverOuEchouer(id);
        ressourceRepository.incrementerPartages(id);
    }

    private void verifierDroitsModification(Ressource ressource, Utilisateur utilisateur) {
        boolean estAuteur = ressource.getAuteur().getId().equals(utilisateur.getId());
        boolean estAdmin = utilisateur.getRole() == Role.admin || utilisateur.getRole() == Role.super_admin;
        if (!estAuteur && !estAdmin) {
            throw new ForbiddenException("Vous ne pouvez pas modifier cette ressource.");
        }
    }

    public Ressource trouverOuEchouer(Integer id) {
        return ressourceRepository.findById(id)
            .orElseThrow(() -> ResourceNotFoundException.of("Ressource", id));
    }
}
