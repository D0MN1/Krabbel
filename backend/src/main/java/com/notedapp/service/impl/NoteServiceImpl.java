package com.notedapp.service.impl;

import com.notedapp.dto.note.NoteRequest;
import com.notedapp.dto.note.NoteResponse;
import com.notedapp.entity.Note;
import com.notedapp.entity.User;
import com.notedapp.dto.note.NoteMapper;
import com.notedapp.repository.NoteRepository;
import com.notedapp.service.NoteService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class NoteServiceImpl implements NoteService {

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private NoteMapper noteMapper;

    @Override
    public List<NoteResponse> getUserNotes(User user) {
        return noteRepository.findByUser(user).stream()
                .map(noteMapper::toNoteResponse)
                .collect(Collectors.toList());
    }

    @Override
    public NoteResponse createNote(User user, NoteRequest request) {
        Note note = noteMapper.toNote(request);
        note.setUser(user);
        note = noteRepository.save(note);
        return noteMapper.toNoteResponse(note);
    }

    @Override
    public NoteResponse updateNote(User user, Long noteId, NoteRequest request) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new EntityNotFoundException("Note not found"));

        if (!note.getUser().equals(user)) {
            throw new IllegalAccessError("You are not allowed to update this note");
        }

        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        note.setPublic(request.isPublic());
        note.setTags(request.getTags());
        note.setImageUrl(request.getImageUrl());

        note = noteRepository.save(note);
        return noteMapper.toNoteResponse(note);
    }

    @Override
    public void deleteNote(User user, Long noteId) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new EntityNotFoundException("Note not found"));

        if (!note.getUser().equals(user)) {
            throw new IllegalAccessError("You are not allowed to delete this note");
        }

        noteRepository.delete(note);
    }

    @Override
    public NoteResponse getNote(User user, Long noteId) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new EntityNotFoundException("Note not found"));

        if (!note.getUser().equals(user)) {
            throw new IllegalAccessError("You are not allowed to access this note");
        }

        return noteMapper.toNoteResponse(note);
    }

    @Override
    public List<NoteResponse> getPublicNotes() {
        return noteRepository.findByIsPublic(true).stream()
                .map(noteMapper::toNoteResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<NoteResponse> getPublicNotesByUserId(Long userId) {
        return null;
    }

    @Override
    public NoteResponse getPublicNoteById(Long noteId) {
        return null;
    }

    @Override
    public NoteResponse archiveNote(User user, Long noteId) {
        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new EntityNotFoundException("Note not found"));

        if (!note.getUser().equals(user)) {
            throw new IllegalAccessError("You are not allowed to archive this note");
        }

        note.setArchived(true);
        note = noteRepository.save(note);
        return noteMapper.toNoteResponse(note);
    }
}