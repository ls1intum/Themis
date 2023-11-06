*******************
Development Process
*******************

.. contents:: Contents
    :local:
    :depth: 1

Naming Conventions for GitHub Pull Requests
===========================================

1. The first term is a main feature of Themis and is using code highlighting, e.g.  “``Programming Exercise``:”.

    1. Possible feature tags are: ``Programming Exercise``, ``Text Exercise``, ``Modeling Exercises``, ``File Upload Exercise``, ``Exam Mode``, ``Assessment View``, ``Course View``, ``Exercise View``, ``Login``, ``Documentation``.
    2. If the change is not visible to end users, or it is a pure development or test improvement, we use the term “``Development``:”.
    3. Everything else belongs to the ``General`` category.

2. The colon is not highlighted.

3. After the colon, there should be a verbal form that is understandable by end users and non-technical persons.

    1. The text should be short, non-capitalized (except the first word) and should include the most important keywords. Do not repeat the feature if it is possible.
    2. We generally distinguish between bugfixes (the verb “Fix”) and improvements (all kinds of verbs) in the release notes. This should be immediately clear from the title.
    3. Good examples:

        - ``Exercise View``: Allow users to cancel submissions
        - ``Assessment View``: Fix an issue when clicking on the save button


Creating and Merging a Pull Request
========================================

Precondition
---------------------------------

* Check if the functionality already exists in the `ArtemisCore <https://github.com/ls1intum/artemis-ios-core-modules>`_ dependency

    If it does not, consider whether the change would also be useful for other iOS clients. If yes, create the PR in
    the ArtemisCore repository instead.

* Limit yourself to one functionality per pull request.
* Split up your task in multiple branches & pull requests if necessary.
* `Commit Early, Commit Often, Perfect Later, Publish Once. <https://speakerdeck.com/lemiorhan/10-git-anti-patterns-you-should-be-aware-of>`_

1. Start Implementation
-----------------------------------------

* `Open a draft pull request. <https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request>`_ This allows for code related questions and discussions.

2. Complete the implementation
---------------------------------------------

* Explain the changes you made in the pull request description
* Add screenshots if the changes affect the UI
* Have a look at the changes to make sure that the changes are only the ones necessary.
* Make sure that the build and the SwiftLint GitHub actions are passing
* Mark the pull request as `ready for review. <https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/changing-the-stage-of-a-pull-request>`_

3. Review
---------

Developer
^^^^^^^^^
* Actively look for reviews. Do not just open the pull request and wait.

Reviewer
^^^^^^^^
* Verify that the new functionality is working as expected.
* Verify that related functionality is still working as expected.
* Check the changes to
    * conform with the code style.
    * make sure you can easily understand the code.
    * make sure that (extensive) comments are present where deemed necessary.
    * performance is reasonable (e.g. number of API calls).
* Submit your comments and status (👍 Approve or 👎 Request Changes) using GitHub.
    * Explain what you did (test, review code) in the review comment.

4. Respond to review
--------------------

Developer
^^^^^^^^^
* Use the pull request to discuss comments or ask questions.
* Update your code where necessary.
* Revert to draft if the changes will take a while during which review is not needed/possible.
* Set back to ready for review afterwards.
* Notify the reviewer(s) once your revised version is ready for the next review.
* Comment on "inline comments" (e.g. "Done").

Reviewer
^^^^^^^^
* Respond to questions raised by the reviewer.
* Mark conversations as resolved if the change is sufficient.

Iterate steps 3 & 4 until ready for merge (all reviewers approve 👍)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

5. Merge
--------
A project maintainer merges your changes into the ``develop`` branch.