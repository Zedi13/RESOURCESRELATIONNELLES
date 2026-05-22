package fr.ressources.relationnelles.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum Visibilite {
    privee, partagee, publique;

    @JsonValue
    public String toJson() { return this.name().toUpperCase(); }

    @JsonCreator
    public static Visibilite fromJson(String value) {
        return valueOf(value.toLowerCase());
    }
}
