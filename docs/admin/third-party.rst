Third-party Components
===========================================

***************
Themis iPad App
***************


Introduction
------------

The Themis iPad App utilizes a number of open-source libraries to enhance its functionality and provide a seamless user experience. 
This provides an overview of the libraries used in the Themis app.

KeychainAccess
--------------

The KeychainAccess library is used to securely store and retrieve sensitive information, 
such as authentication tokens. 
KeychainAccess provides a simple and secure way to store data in the iOS keychain.

Library repository: https://github.com/kishikawakatsumi/KeychainAccess (master branch)


SwiftUI-Cached-AsyncImage
-------------------------

The SwiftUI-Cached-AsyncImage library provides an easy way to load and cache images asynchronously in SwiftUI. 
This library is used in the Themis iPad App to display UML-Diagrams in a fast and efficient manner.

Library repository: https://github.com/lorenzofiamingo/swiftui-cached-async-image (2.0.0 - Next Major)

CodeEditor
------------

The CodeEditor library is a customizable and extensible code editor component for SwiftUI. The 
library is used in the Themis iPad App to provide a code editor for the user to read code.
It was modified locally in order to select and give feedback in the code editor

Library repository: https://github.com/ZeeZide/CodeEditor.git (locally modified)

SwiftUIReorderableForEach
-------------------------

The SwiftUIReorderableForEach library is used to create reorderable lists in SwiftUI. 
This library is used in the Themis iPad App to provide the user with the ability to reorder the tabs for open code files.

Library repository: https://github.com/globulus/swiftui-reorderable-foreach (main branch)


Swift-Markdown-ui
-----------------

The Swift-Markdown-ui library is used to parse and display markdown content in a SwiftUI app. 
This library is used in the Themis iPad App to display markdown content from Artemis in a clean and formatted manner.

Library repository: https://github.com/gonzalezreal/swift-markdown-ui (2.0.0 - next major)


***************
ThemisML Server 
***************

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
-------------------
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