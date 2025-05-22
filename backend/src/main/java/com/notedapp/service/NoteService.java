package com.notedapp.service;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.User;

import java.util.List;

public interface NoteService {
    List<NoteResponse> getUserNotes(User user);
    NoteResponse createNote(User user, NoteRequest request);
    NoteResponse updateNote(User user, Long noteId, NoteRequest request);
    void deleteNote(User user, Long noteId);
    NoteResponse getNote(User user, Long noteId);
    List<NoteResponse> searchNotes(User user, String keyword);
}