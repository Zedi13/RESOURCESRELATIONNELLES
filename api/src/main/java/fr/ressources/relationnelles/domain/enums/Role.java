package fr.ressources.relationnelles.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

// Noms en minuscules pour correspondre exactement aux valeurs ENUM MySQL
public enum Role {
    citoyen, moderateur, admin, super_admin;

    @JsonValue
    public String toJson() { return this.name().toUpperCase(); }

    @JsonCreator
    public static Role fromJson(String value) {
        return valueOf(value.toLowerCase());
    }
}
