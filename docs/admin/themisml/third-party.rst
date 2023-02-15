Third-party Components
===========================================

Server
------------
ThemisML uses `FastAPI`_ for the web server and `uvicorn`_ as the ASGI server.

Library repository FastAPI: https://github.com/tiangolo/fastapi (0.88.0)
Library repository uvicorn: https://github.com/encode/uvicorn (0.20.0)

Database
------------
To connect to the PostgreSQL database, ThemisML uses `SQLAlchemy`_ as the client and `Psycopg2`_ as the database driver.

Library repository SQLAlchemy: https://github.com/sqlalchemy/sqlalchemy (1.4.46)
Library repository Psycopg2: https://github.com/psycopg/psycopg2 (2.9.5)

Feedback generation
------------
For extracting the methods, we use `ANTL4`_ for python.
To compare code, we use `CodeBERTScore`_, which is a wrapper for CodeBERT. Because it is not available on PyPI, we directly link to the GitHub repository in our requirements.

Library repository ANTL4: https://github.com/antlr/antlr4 (4.11.1)

Helpers
------------
The helper script ``determine-similarity-cutoff`` uses the `dataset`_ library to simplify working with the database.

Library repository dataset: https://github.com/pudo/dataset (1.6.0)

You can find the full list of third-party requirements including the most up-to-date version numbers in use in the ``requirements.txt`` files in the respective folders of the ThemisML repository. The main one is found in `feedback-suggestion/requirements.txt <https://github.com/ls1intum/Themis-ML/blob/develop/feedback-suggestion/requirements.txt>`_.

.. links
.. _FastAPI: https://fastapi.tiangolo.com/
.. _uvicorn: https://www.uvicorn.org/
.. _SQLAlchemy: https://www.sqlalchemy.org/
.. _Psycopg2: https://www.psycopg.org/
.. _ANTL4: https://www.antlr.org/
.. _CodeBERTScore: https://github.com/neulab/code-bert-score
.. _dataset: https://dataset.readthedocs.io/en/latest/