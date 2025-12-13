       IDENTIFICATION DIVISION.
       PROGRAM-ID. example.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  DB-USER     PIC X(64).
       01  DB-PASS     PIC X(64) VALUE SPACE.
       01  DB-NAME     PIC X(64) VALUE "pgvector_cobol_test".
       01  EMBEDDING   PIC X(1024).
       01  EMBEDDING2  PIC X(1024).
       01  NEAREST-ID  PIC X(20).
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
           ACCEPT DB-USER FROM ENVIRONMENT "USER".
           EXEC SQL
               CONNECT :DB-USER IDENTIFIED BY :DB-PASS USING :DB-NAME
           END-EXEC.

           EXEC SQL
               CREATE EXTENSION IF NOT EXISTS vector
           END-EXEC.

           EXEC SQL
               DROP TABLE IF EXISTS items
           END-EXEC.

           EXEC SQL
               CREATE TABLE items (
                   id bigserial PRIMARY KEY,
                   embedding vector(3)
               )
           END-EXEC.

           MOVE "[1,2,3]" TO EMBEDDING.
           MOVE "[4,5,6]" TO EMBEDDING2.
           EXEC SQL
               INSERT INTO items (embedding)
                   VALUES (:EMBEDDING), (:EMBEDDING2)
           END-EXEC.

           EXEC SQL COMMIT WORK END-EXEC.

           MOVE "[3,1,2]" TO EMBEDDING.
           EXEC SQL
               SELECT id INTO :NEAREST-ID FROM items
                   ORDER BY embedding <-> :EMBEDDING LIMIT 5
           END-EXEC.
           DISPLAY "Nearest ID: " NEAREST-ID.

           EXEC SQL
               DISCONNECT ALL
           END-EXEC.

           GOBACK.
