package fr.ressources.relationnelles.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum StatutRessource {
    brouillon, en_attente, publie, suspendu, archive;

    @JsonValue
    public String toJson() { return this.name().toUpperCase(); }

    @JsonCreator
    public static StatutRessource fromJson(String value) {
        return valueOf(value.toLowerCase());
    }
}
