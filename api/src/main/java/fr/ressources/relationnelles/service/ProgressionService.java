package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.*;
import fr.ressources.relationnelles.dto.response.ProgressionResponse;
import fr.ressources.relationnelles.dto.response.RessourceSummaryResponse;
import fr.ressources.relationnelles.mapper.RessourceMapper;
import fr.ressources.relationnelles.repository.ExploitationRepository;
import fr.ressources.relationnelles.repository.FavoriRepository;
import fr.ressources.relationnelles.repository.SauvegardeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProgressionService {

    private final FavoriRepository favoriRepository;
    private final ExploitationRepository exploitationRepository;
    private final SauvegardeRepository sauvegardeRepository;
    private final RessourceService ressourceService;
    private final RessourceMapper ressourceMapper;

    public ProgressionResponse getProgression(Utilisateur utilisateur) {
        List<RessourceSummaryResponse> favoris = favoriRepository.findByUtilisateurId(utilisateur.getId())
            .stream().map(f -> ressourceMapper.toSummary(f.getRessource())).collect(Collectors.toList());

        List<RessourceSummaryResponse> exploitees = exploitationRepository.findByUtilisateurId(utilisateur.getId())
            .stream().map(e -> ressourceMapper.toSummary(e.getRessource())).collect(Collectors.toList());

        List<RessourceSummaryResponse> sauvegardees = sauvegardeRepository.findByUtilisateurId(utilisateur.getId())
            .stream().map(s -> ressourceMapper.toSummary(s.getRessource())).collect(Collectors.toList());

        return ProgressionResponse.builder()
            .favoris(favoris)
            .ressourcesExploitees(exploitees)
            .ressourcesSauvegardees(sauvegardees)
            .totalFavoris(favoris.size())
            .totalExploitees(exploitees.size())
            .totalSauvegardees(sauvegardees.size())
            .build();
    }

    @Transactional
    public void ajouterFavori(Integer ressourceId, Utilisateur utilisateur) {
        if (!favoriRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId)) {
            Ressource ressource = ressourceService.trouverOuEchouer(ressourceId);
            favoriRepository.save(Favori.builder().utilisateur(utilisateur).ressource(ressource).build());
        }
    }

    @Transactional
    public void retirerFavori(Integer ressourceId, Utilisateur utilisateur) {
        favoriRepository.deleteByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId);
    }

    @Transactional
    public void marquerExploitee(Integer ressourceId, Utilisateur utilisateur) {
        if (!exploitationRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId)) {
            Ressource ressource = ressourceService.trouverOuEchouer(ressourceId);
            exploitationRepository.save(Exploitation.builder().utilisateur(utilisateur).ressource(ressource).build());
        }
    }

    @Transactional
    public void demarquerExploitee(Integer ressourceId, Utilisateur utilisateur) {
        exploitationRepository.deleteByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId);
    }

    @Transactional
    public void sauvegarder(Integer ressourceId, Utilisateur utilisateur) {
        if (!sauvegardeRepository.existsByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId)) {
            Ressource ressource = ressourceService.trouverOuEchouer(ressourceId);
            sauvegardeRepository.save(Sauvegarde.builder().utilisateur(utilisateur).ressource(ressource).build());
        }
    }

    @Transactional
    public void retirerSauvegarde(Integer ressourceId, Utilisateur utilisateur) {
        sauvegardeRepository.deleteByUtilisateurIdAndRessourceId(utilisateur.getId(), ressourceId);
    }
}
