package com.notedapp.repository;

import com.notedapp.entity.Note;
import com.notedapp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    List<Note> findByUserAndIsDeletedFalse(User user);
    List<Note> findByUserAndIsDeletedFalseOrderByUpdatedAtDesc(User user);
    Optional<Note> findByIdAndUser(Long id, User user);
    List<Note> findByUserAndIsDeletedFalseAndTitleContainingIgnoreCaseOrUserAndIsDeletedFalseAndContentContainingIgnoreCase(
            User user, String titleKeyword, User sameUser, String contentKeyword);
} 