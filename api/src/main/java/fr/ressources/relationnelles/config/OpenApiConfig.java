package fr.ressources.relationnelles.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    private static final String BEARER_KEY = "bearerAuth";

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("(RE)Sources Relationnelles API")
                .description("API REST pour la plateforme (RE)Sources Relationnelles. " +
                             "Sert l'application mobile Flutter et l'application web.")
                .version("1.0.0")
                .license(new License().name("Ministère des Solidarités et de la Santé"))
            )
            .addSecurityItem(new SecurityRequirement().addList(BEARER_KEY))
            .components(new Components()
                .addSecuritySchemes(BEARER_KEY, new SecurityScheme()
                    .name(BEARER_KEY)
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
                    .description("Entrez le token JWT obtenu via POST /api/auth/login")
                )
            );
    }
}
