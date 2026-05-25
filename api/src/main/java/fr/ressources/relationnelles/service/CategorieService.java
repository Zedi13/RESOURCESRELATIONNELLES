package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.Categorie;
import fr.ressources.relationnelles.dto.request.CategorieRequest;
import fr.ressources.relationnelles.dto.response.CategorieResponse;
import fr.ressources.relationnelles.exception.ConflictException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.mapper.CategorieMapper;
import fr.ressources.relationnelles.repository.CategorieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategorieService {

    private final CategorieRepository categorieRepository;
    private final CategorieMapper categorieMapper;

    @Transactional(readOnly = true)
    public List<CategorieResponse> listerActives() {
        return categorieRepository.findByEstActiveTrueOrderByOrdreAsc()
            .stream().map(categorieMapper::toResponse).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<CategorieResponse> listerToutes() {
        return categorieRepository.findAll()
            .stream().map(categorieMapper::toResponse).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public CategorieResponse getById(Integer id) {
        return categorieMapper.toResponse(trouverOuEchouer(id));
    }

    @Transactional
    public CategorieResponse creer(CategorieRequest request) {
        if (categorieRepository.existsByNom(request.nom())) {
            throw new ConflictException("Une catégorie avec ce nom existe déjà.");
        }
        Categorie categorie = Categorie.builder()
            .nom(request.nom())
            .description(request.description())
            .couleur(request.couleur() != null && !request.couleur().isBlank() ? request.couleur() : "#2E86AB")
            .icone(request.icone() != null && !request.icone().isBlank() ? request.icone() : "category")
            .ordre(request.ordre())
            .build();
        return categorieMapper.toResponse(categorieRepository.save(categorie));
    }

    @Transactional
    public CategorieResponse modifier(Integer id, CategorieRequest request) {
        Categorie categorie = trouverOuEchouer(id);
        if (categorieRepository.existsByNomAndIdNot(request.nom(), id)) {
            throw new ConflictException("Une catégorie avec ce nom existe déjà.");
        }
        categorie.setNom(request.nom());
        categorie.setDescription(request.description());
        categorie.setCouleur(request.couleur() != null && !request.couleur().isBlank() ? request.couleur() : "#2E86AB");
        categorie.setIcone(request.icone() != null && !request.icone().isBlank() ? request.icone() : "category");
        categorie.setOrdre(request.ordre());
        return categorieMapper.toResponse(categorieRepository.save(categorie));
    }

    @Transactional
    public void supprimer(Integer id) {
        Categorie categorie = trouverOuEchouer(id);
        if (!categorie.getRessources().isEmpty()) {
            // Désactivation soft plutôt que suppression si des ressources y sont attachées
            categorie.setEstActive(false);
            categorieRepository.save(categorie);
        } else {
            categorieRepository.delete(categorie);
        }
    }

    public Categorie trouverOuEchouer(Integer id) {
        return categorieRepository.findById(id)
            .orElseThrow(() -> ResourceNotFoundException.of("Catégorie", id));
    }
}
