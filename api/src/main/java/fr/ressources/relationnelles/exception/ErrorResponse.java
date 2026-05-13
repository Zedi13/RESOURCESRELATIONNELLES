package fr.ressources.relationnelles.exception;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorResponse {
    private int status;
    private String erreur;
    private String message;
    private String chemin;
    private LocalDateTime timestamp;
    private Map<String, String> erreurs; // Pour les erreurs de validation champ par champ
}
