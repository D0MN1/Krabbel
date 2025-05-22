package com.notedapp.controller;


// If NoteService does not exist, create it in com.notedapp.service package

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;
import com.notedapp.service.NoteService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

   @GetMapping
public ResponseEntity<List<NoteResponse>> getUserNotes(@AuthenticationPrincipal User user) {
    if (user == null) {
        System.out.println("⚠️ GEEN ingelogde gebruiker ontvangen!");
    } else {
        System.out.println("✅ Ingelogde gebruiker: " + user.getEmail());
    }

    return ResponseEntity.ok(noteService.getUserNotes(user));
}


    @PostMapping
    public ResponseEntity<NoteResponse> createNote(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody NoteRequest request) {
        return ResponseEntity.ok(noteService.createNote(user, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<NoteResponse> updateNote(
            @AuthenticationPrincipal User user,
            @PathVariable Long id,
            @Valid @RequestBody NoteRequest request) {
        return ResponseEntity.ok(noteService.updateNote(user, id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(
            @AuthenticationPrincipal User user,
            @PathVariable Long id) {
        noteService.deleteNote(user, id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<NoteResponse> getNote(
            @AuthenticationPrincipal User user,
            @PathVariable Long id) {
        return ResponseEntity.ok(noteService.getNote(user, id));
    }
} 