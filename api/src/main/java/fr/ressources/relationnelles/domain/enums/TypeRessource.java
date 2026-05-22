package fr.ressources.relationnelles.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum TypeRessource {
    article, video, audio, activite, jeu, podcast, document, lien;

    @JsonValue
    public String toJson() { return this.name().toUpperCase(); }

    @JsonCreator
    public static TypeRessource fromJson(String value) {
        return valueOf(value.toLowerCase());
    }
}
