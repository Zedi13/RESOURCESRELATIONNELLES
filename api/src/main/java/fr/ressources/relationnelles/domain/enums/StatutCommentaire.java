package fr.ressources.relationnelles.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum StatutCommentaire {
    en_attente, approuve, rejete;

    @JsonValue
    public String toJson() { return this.name().toUpperCase(); }

    @JsonCreator
    public static StatutCommentaire fromJson(String value) {
        return valueOf(value.toLowerCase());
    }
}
