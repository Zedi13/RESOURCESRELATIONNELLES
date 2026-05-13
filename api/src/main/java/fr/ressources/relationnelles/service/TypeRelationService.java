package fr.ressources.relationnelles.service;

import fr.ressources.relationnelles.domain.entity.TypeRelation;
import fr.ressources.relationnelles.dto.request.TypeRelationRequest;
import fr.ressources.relationnelles.dto.response.TypeRelationResponse;
import fr.ressources.relationnelles.exception.ConflictException;
import fr.ressources.relationnelles.exception.ResourceNotFoundException;
import fr.ressources.relationnelles.mapper.TypeRelationMapper;
import fr.ressources.relationnelles.repository.TypeRelationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TypeRelationService {

    private final TypeRelationRepository typeRelationRepository;
    private final TypeRelationMapper typeRelationMapper;

    public List<TypeRelationResponse> listerTous() {
        return typeRelationRepository.findAllByOrderByOrdreAsc()
            .stream().map(typeRelationMapper::toResponse).collect(Collectors.toList());
    }

    @Transactional
    public TypeRelationResponse creer(TypeRelationRequest request) {
        if (typeRelationRepository.existsByLibelle(request.libelle())) {
            throw new ConflictException("Un type de relation avec ce libellé existe déjà.");
        }
        TypeRelation tr = TypeRelation.builder()
            .libelle(request.libelle())
            .description(request.description())
            .ordre(request.ordre())
            .build();
        return typeRelationMapper.toResponse(typeRelationRepository.save(tr));
    }

    @Transactional
    public TypeRelationResponse modifier(Integer id, TypeRelationRequest request) {
        TypeRelation tr = trouverOuEchouer(id);
        if (typeRelationRepository.existsByLibelleAndIdNot(request.libelle(), id)) {
            throw new ConflictException("Un type de relation avec ce libellé existe déjà.");
        }
        tr.setLibelle(request.libelle());
        tr.setDescription(request.description());
        tr.setOrdre(request.ordre());
        return typeRelationMapper.toResponse(typeRelationRepository.save(tr));
    }

    @Transactional
    public void supprimer(Integer id) {
        typeRelationRepository.delete(trouverOuEchouer(id));
    }

    public TypeRelation trouverOuEchouer(Integer id) {
        return typeRelationRepository.findById(id)
            .orElseThrow(() -> ResourceNotFoundException.of("TypeRelation", id));
    }
}
