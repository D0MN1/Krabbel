package com.notedapp.service.impl;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;
import com.notedapp.service.NoteService; // Import NoteService
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteServiceImpl implements NoteService {

    @Override
    public List<NoteResponse> getUserNotes(User user) {
        // Implement this method
        return null;
    }

    @Override
    public NoteResponse createNote(User user, NoteRequest request) {
        // Implement this method
        return null;
    }

    @Override
    public NoteResponse updateNote(User user, Long noteId, NoteRequest request) {
        // Implement this method
        return null;
    }

    @Override
    public void deleteNote(User user, Long noteId) {
        // Implement this method
    }

    @Override
    public NoteResponse getNote(User user, Long noteId) {
        // Implement this method
        return null;
    }

    @Override
    public List<NoteResponse> getPublicNotes() {
        // Implement this method
        return null;
    }

    @Override
    public List<NoteResponse> getPublicNotesByUserId(Long userId) {
        // Implement this method
        return null;
    }

    @Override
    public NoteResponse getPublicNoteById(Long noteId) {
        // Implement this method
        return null;
    }
}