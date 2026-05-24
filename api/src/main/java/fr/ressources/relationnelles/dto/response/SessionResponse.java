package fr.ressources.relationnelles.dto.response;

import java.util.List;

public record SessionResponse(
    Integer id,
    String code,
    Integer ressourceId,
    String ressourceTitre,
    Integer createurId,
    String createurNom,
    String statut,
    String dateCreation,
    List<ParticipantInfo> participants,
    List<MessageInfo> messages
) {
    public record ParticipantInfo(
        Integer id,
        String nom
    ) {}

    public record MessageInfo(
        Integer id,
        Integer auteurId,
        String auteurNom,
        String contenu,
        String dateEnvoi
    ) {}
}
