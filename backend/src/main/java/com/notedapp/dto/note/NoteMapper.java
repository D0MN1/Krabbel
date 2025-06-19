package com.notedapp.dto.note;

import com.notedapp.entity.Note;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface NoteMapper {

    NoteResponse toNoteResponse(Note note);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "isDeleted", ignore = true)
    @Mapping(target = "isArchived", ignore = true)
    Note toNote(NoteRequest noteRequest);
}

