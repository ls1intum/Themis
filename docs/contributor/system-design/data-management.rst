Persistent Data Management
--------------------------

The app stores the authentication cookie in the HTTPCookieStorage, which is described in the :ref:`Access Control and Security<Access Control and Security>` Chapter.


***************
UserDefaults
***************

The app stores the selected Course ID (which are the ones provided by Artemis) in the UserDefaults at **"shownCourseIDKey"** in order to always show the last selected
course.
The Artemis server URL is also stored in the UserDefaults at **"serverURL"**.


***************
ThemisML Server
***************
.. TODO: Remove once Athena is fully integrated
.. note:: *This section will be removed once feedback suggestions are completely integrated into Artemis.*

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