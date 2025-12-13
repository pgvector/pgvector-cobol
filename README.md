# pgvector-cobol

[pgvector](https://github.com/pgvector/pgvector) examples for COBOL

Supports [Open Cobol ESQL](https://github.com/opensourcecobol/Open-COBOL-ESQL)

[![Build Status](https://github.com/pgvector/pgvector-cobol/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-cobol/actions)

## Getting Started

Follow the instructions for your database library:

- [Open Cobol ESQL](#open-cobol-esql)

## Open Cobol ESQL

Enable the extension

```text
EXEC SQL
    CREATE EXTENSION IF NOT EXISTS vector
END-EXEC.
```

Create a table

```text
EXEC SQL
    CREATE TABLE items (
        id bigserial PRIMARY KEY,
        embedding vector(3)
    )
END-EXEC.
```

Insert vectors

```text
MOVE "[1,2,3]" TO EMBEDDING.
MOVE "[4,5,6]" TO EMBEDDING2.
EXEC SQL
    INSERT INTO items (embedding)
        VALUES (:EMBEDDING), (:EMBEDDING2)
END-EXEC.
```

Get the nearest neighbor

```text
MOVE "[3,1,2]" TO EMBEDDING.
EXEC SQL
    SELECT id INTO :NEAREST-ID FROM items
        ORDER BY embedding <-> :EMBEDDING LIMIT 5
END-EXEC.
```

See a [full example](example.cbl)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-cobol/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-cobol/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-cobol.git
cd pgvector-cobol
createdb pgvector_cobol_test
ocesql example.cbl example.cob
export COBCPY=path/to/Open-COBOL-ESQL/copy
cobc -x -locesql example.cob
./example
```
