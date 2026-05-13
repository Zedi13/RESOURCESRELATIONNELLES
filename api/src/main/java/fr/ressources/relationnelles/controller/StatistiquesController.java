package fr.ressources.relationnelles.controller;

import fr.ressources.relationnelles.dto.response.StatistiquesResponse;
import fr.ressources.relationnelles.service.StatistiquesService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/api/statistiques")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
@Tag(name = "Statistiques", description = "Tableau de bord et export des statistiques")
public class StatistiquesController {

    private final StatistiquesService statistiquesService;

    @GetMapping
    @Operation(summary = "Tableau de bord statistiques (admin)")
    public ResponseEntity<StatistiquesResponse> getDashboard() {
        return ResponseEntity.ok(statistiquesService.getDashboard());
    }

    @GetMapping("/export")
    @Operation(summary = "Exporter les statistiques au format CSV (admin)")
    public ResponseEntity<byte[]> exportCsv() {
        String csv = statistiquesService.exportCsv();
        byte[] content = csv.getBytes(StandardCharsets.UTF_8);

        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"statistiques.csv\"")
            .contentType(MediaType.parseMediaType("text/csv; charset=UTF-8"))
            .contentLength(content.length)
            .body(content);
    }
}
