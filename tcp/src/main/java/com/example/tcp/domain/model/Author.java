package com.example.tcp.domain.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.Set;
import java.util.UUID;

    @Entity
    @Table(name = "author")
    public class Author {
        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        public UUID authorid;
        public String name;
        public String imageurl;

        @ManyToMany(mappedBy = "author")
        @JsonIgnoreProperties("author")
        public Set<Anime> animes;
}
