package com.notedapp.controller;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;
import org.springframework.security.core.userdetails.UserDetails;
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
    public ResponseEntity<List<NoteResponse>> getUserNotes(@AuthenticationPrincipal UserDetails userDetails) {
        User user = (User) userDetails;
        return ResponseEntity.ok(noteService.getUserNotes(user));
    }
    @PostMapping
    public ResponseEntity<NoteResponse> createNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody NoteRequest request) {
        User user = (User) userDetails;
        return ResponseEntity.ok(noteService.createNote(user, request));
    }
    @PutMapping("/{id}")
    public ResponseEntity<NoteResponse> updateNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id,
            @Valid @RequestBody NoteRequest request) {
        User user = (User) userDetails;
        return ResponseEntity.ok(noteService.updateNote(user, id, request));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id) {
        User user = (User) userDetails;
        noteService.deleteNote(user, id);
        return ResponseEntity.ok().build();
    }
    @PatchMapping("/{id}/archive")
    public ResponseEntity<NoteResponse> archiveNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id) {
        User user = (User) userDetails;
        return ResponseEntity.ok(noteService.archiveNote(user, id));
    }
    public ResponseEntity<NoteResponse> archiveNote(
            @AuthenticationPrincipal User user,
            @PathVariable Long id) {
        return ResponseEntity.ok(noteService.archiveNote(user, id));
    }
}