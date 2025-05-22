package com.notedapp.service;

import java.util.List;

import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.ComponentScan;


import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;


@ComponentScan({"com.notedapp", "com.example.service"}) // Add the package
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

public interface NoteService {
    List<NoteResponse> getUserNotes(User user);
    NoteResponse createNote(User user, NoteRequest request);
    NoteResponse updateNote(User user, Long noteId, NoteRequest request);
    void deleteNote(User user, Long noteId);
    NoteResponse getNote(User user, Long noteId);
    List<NoteResponse> getPublicNotes();  // <- deze toevoegen
    List<NoteResponse> getPublicNotesByUserId(Long userId); // <- deze toevoegen
    NoteResponse getPublicNoteById(Long noteId); // <- deze toevoegen
    
} 
}