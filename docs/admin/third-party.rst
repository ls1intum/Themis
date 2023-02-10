Third-party Components
===========================================

.. List all third-party components you use (e.g. libraries, frameworks) and include their version numbers. If you used open source components add a link to the website and/or the license terms. If you used commercial software refer to the product information at the manufacturer site.

*****
Themis iPad App
*****
iOS Tom Rudnick,
Rearranging Files Katjana Kosic,

*****
ThemisML
*****

ThemisML uses `FastAPI`_ for the web server and `uvicorn`_ as the ASGI server.
To connect to the PostgreSQL database, ThemisML uses `SQLAlchemy`_ as the client and `Psycopg2`_ as the database driver.

For extracting the methods, we use `ANTL4`_ for python.

To compare code, we use `CodeBERTScore`_, which is a wrapper for CodeBERT. Because it is not available on PyPI, we directly link to the GitHub repository in our requirements.

The helper script ``determine-similarity-cutoff`` uses the `dataset`_ library to simplify working with the database.

You can find the full list of third-party requirements including the most up-to-date version numbers in use in the ``requirements.txt`` files in the respective folders of the ThemisML repository. The main one is found in `feedback-suggestion/requirements.txt <https://github.com/ls1intum/Themis-ML/blob/develop/feedback-suggestion/requirements.txt>`_.

.. links
.. _FastAPI: https://fastapi.tiangolo.com/
.. _uvicorn: https://www.uvicorn.org/
.. _SQLAlchemy: https://www.sqlalchemy.org/
.. _Psycopg2: https://www.psycopg.org/
.. _ANTL4: https://www.antlr.org/
.. _CodeBERTScore: https://github.com/neulab/code-bert-score
.. _dataset: https://dataset.readthedocs.io/en/latest/