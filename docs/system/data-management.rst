Persistent Data Management
===========================================

.. Persistent data management describes the persistent data stored by the system and the data management infrastructure required for it. This section typically includes the description of data schemes, the selection of a database, and the description of the encapsulation of the database. This section is optional. It should be included if your architecture includes a data centric subsystem. For details refer to section 7.4.2 in Prof. Bruegge's book.

*****
Themis App
*****

.. (Tom)

*****
ThemisML Server
*****
ThemisML has a Postgres database separate from the Artemis database to store existing feedbacks for given submissions. The choice of the database follows a related project to ThemisML, `Athene`_.
In principle, ThemisML could use the Artemis database directly, but the development team decided to use a separate database for a faster development cycle and more flexibility. The database might be merged in the future.

Currently, ThemisML fetches submissions from Artemis only when it is notified from the app using the ``/feedback_suggestions/notify`` endpoint. Then, the feedbacks are fetched and the following data is stored in the database for each feedback:

* a unique ``id`` within ThemisML
* the ``exercise_id`` of the submission
* the ``participation_id`` of the submission
* the ``method_name`` of the method belonging to the feedback (ThemisML currently does not work for feedbacks outside of methods, so those are not stored)
* the ``code`` of the method belonging to the feedback
* the ``src_file`` of the method belonging to the feedback
* ``from_line`` and ``to_line`` of the feedback within the ``src_file``
* the ``text`` of the feedback
* the ``credits`` given by the tutor


.. _Athene: https://github.com/ls1intum/Athena