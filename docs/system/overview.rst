Overview
===========================================

.. Include and describe the Workflow here in terms of the main components and technologies used.

Themis is a native iPad app using SwiftUI, which mainly communicates with Artemis-Servers via REST calls.
It also communicates with a ThemisML server written in Python for the feedback suggestions feature.

Typically, a tutor will open the Themis app on their iPad and log in to the Artemis server of their choice. They can choose any Artemis server URL, which will be saved for future use.
Once logged in, they can choose a course and an exercise from the respective lists of available courses and exercises. The tutor can then start the exercise and begin grading student submissions.
When opening a submission, the app will initiate a request to ThemisML, which is authenticated with the very same token that's used for the connection to Artemis. ThemisML will then request the submission from the Artemis server (of which the URL is included in the request) and return a list of feedback suggestions.

After the tutor submitted the assessment, the app will send a request to each Artemis with the submission as well as the ThemisML server with the ID so that ThemisML can update its internal state.

The ThemisML server can be deployed independently from Artemis.
