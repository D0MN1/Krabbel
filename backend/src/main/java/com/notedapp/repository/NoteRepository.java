package com.notedapp.repository;

import com.notedapp.entity.Note;
import com.notedapp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    List<Note> findByUser(User user);

    List<Note> findByIsPublic(boolean isPublic);

    List<Note> findAllByUser(User user);

    List<Note> findAllByUserIdAndIsPublicTrue(Long userId);

    List<Note> findAllByUserAndIsFavoriteTrue(User user);

    List<Note> findAllByUserAndIsArchivedTrue(User user);
    
    List<Note> findAllByIsPublicTrue();

    Optional<Note> findByIdAndIsPublicTrue(Long noteId);

    // Nieuwe methodes met soft delete
    List<Note> findAllByUserAndIsDeletedFalse(User user);

    Optional<Note> findByIdAndUserAndIsDeletedFalse(Long id, User user);
}
