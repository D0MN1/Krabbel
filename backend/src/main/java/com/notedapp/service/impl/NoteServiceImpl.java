package com.notedapp.service.impl;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.Note;
import com.notedapp.entity.User;
import com.notedapp.repository.NoteRepository;
import com.notedapp.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class NoteServiceImpl implements NoteService {

    @Autowired
    private NoteRepository noteRepository;

    @Override
    public List<NoteResponse> getUserNotes(User user) {
        return noteRepository.findByUserAndIsDeletedFalseOrderByUpdatedAtDesc(user)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public NoteResponse createNote(User user, NoteRequest request) {
        Note note = new Note();
        note.setUser(user);
        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        
        Note savedNote = noteRepository.save(note);
        return convertToResponse(savedNote);
    }

    @Override
    @Transactional
    public NoteResponse updateNote(User user, Long noteId, NoteRequest request) {
        Note note = noteRepository.findByIdAndUser(noteId, user)
                .orElseThrow(() -> new RuntimeException("Note not found"));
        
        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        
        Note updatedNote = noteRepository.save(note);
        return convertToResponse(updatedNote);
    }

    @Override
    @Transactional
    public void deleteNote(User user, Long noteId) {
        Note note = noteRepository.findByIdAndUser(noteId, user)
                .orElseThrow(() -> new RuntimeException("Note not found"));
        
        note.setDeleted(true);
        noteRepository.save(note);
    }

    @Override
    public NoteResponse getNote(User user, Long noteId) {
        Note note = noteRepository.findByIdAndUser(noteId, user)
                .orElseThrow(() -> new RuntimeException("Note not found"));
        
        return convertToResponse(note);
    }

    private NoteResponse convertToResponse(Note note) {
        return new NoteResponse(
                note.getId(),
                note.getTitle(),
                note.getContent(),
                note.getCreatedAt(),
                note.getUpdatedAt()
        );
    }
} 