package com.notedapp.repository;

import com.notedapp.entity.Note;
import com.notedapp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    List<Note> findByUserAndIsDeletedFalse(User user);
    List<Note> findByUserAndIsDeletedFalseOrderByUpdatedAtDesc(User user);
    Optional<Note> findByIdAndUser(Long id, User user);

    @Query("SELECT n FROM Note n WHERE n.user.id = :userId " +
           "AND (LOWER(n.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(n.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "AND n.isDeleted = false")
    
            List<Note> searchNotes(@Param("userId") Long userId, 
                                  @Param("keyword") String keyword);
} 