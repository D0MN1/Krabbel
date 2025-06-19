package com.notedapp.controller;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;
import com.notedapp.service.NoteService;
import com.notedapp.service.UserService;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notes")
public class NoteController {
    @Autowired
    private NoteService noteService;

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<List<NoteResponse>> getUserNotes(@AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByUsername(userDetails.getUsername());
        return ResponseEntity.ok(noteService.getUserNotes(user));
    }

    @PostMapping
    public ResponseEntity<NoteResponse> createNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody NoteRequest request) {
        User user = userService.findByUsername(userDetails.getUsername());
        return ResponseEntity.ok(noteService.createNote(user, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<NoteResponse> updateNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id,
            @Valid @RequestBody NoteRequest request) {
        User user = userService.findByUsername(userDetails.getUsername());
        return ResponseEntity.ok(noteService.updateNote(user, id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id) {
        User user = userService.findByUsername(userDetails.getUsername());
        noteService.deleteNote(user, id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}/archive")
    public ResponseEntity<NoteResponse> archiveNote(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long id) {
        User user = userService.findByUsername(userDetails.getUsername());
        return ResponseEntity.ok(noteService.archiveNote(user, id));
    }


}
