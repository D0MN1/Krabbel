package com.notedapp.dto.note;

import jakarta.validation.constraints.NotBlank;
public class NoteRequest {
    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Content is required")
    private String content;

    private boolean aPublic;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isaPublic() {
        return aPublic;
    }

    public void setaPublic(boolean aPublic) {
        this.aPublic = aPublic;
    }
}
