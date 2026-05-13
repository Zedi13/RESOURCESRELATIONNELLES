package fr.ressources.relationnelles.config;

import fr.ressources.relationnelles.domain.entity.Utilisateur;
import fr.ressources.relationnelles.domain.enums.Role;
import fr.ressources.relationnelles.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        mettreAJourMotDePasse("admin@ressources-relationnelles.fr",        "Admin@2025");
        mettreAJourMotDePasse("moderateur@ressources-relationnelles.fr",   "password123");
        mettreAJourMotDePasse("admin2@ressources-relationnelles.fr",       "password123");
        mettreAJourMotDePasse("sophie.bernard@email.fr",                   "password123");
        mettreAJourMotDePasse("lucas.petit@email.fr",                      "password123");
        mettreAJourMotDePasse("emma.leroy@email.fr",                       "password123");
        mettreAJourMotDePasse("thomas.moreau@email.fr",                    "password123");
        mettreAJourMotDePasse("clara.simon@email.fr",                      "password123");
        log.info("✅ Mots de passe initialisés correctement.");
    }

    private void mettreAJourMotDePasse(String email, String motDePasse) {
        utilisateurRepository.findByEmail(email).ifPresent(u -> {
            u.setMotDePasse(passwordEncoder.encode(motDePasse));
            utilisateurRepository.save(u);
        });
    }
}
