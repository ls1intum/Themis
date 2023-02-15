Product Backlog
===========================================
The following is a highlight of the most significant backlog items that have been successfully integrated into our project.

* Create app icon/name
* Implement REST API for communication with Artemis
* Implement authentication functionality for Artemis users

  - Use bearer token / cookie based authentication based on Artemis version
* Implement functionality to view and switch between the tutors courses
* Implement view that shows all exercises for a course and allows selecting them

  - Show a timeline indicating release-, submission- and assessment (due) dates
* Implement view that shows assessment statistics for a specific exercise
* Implement functionality to search for a specific student's submission
* Implement functionality to open a submission in read-only-mode
* Implement functionality to start the assessment of a randomly assigned submission
* Implement functionality to continue the assessment of a previously saved/submitted assessment
* Implement view that is used for the assessment workflow

  - Show an expandable file tree of the submissions repository that allows selecting files
  - Show all opened files as dismissable / rearrangeable tabs above the code editor
  - Show the source code of the selected file in a code editor

    + Apply dynamic syntax highlighting based on the file extension
    + Show the student's changes as a diff
    + Highlight all code-specific inline feedbacks
    + Toggle feedback edit-mode when clicking on inline highlight
    + Indicate available feedback suggestions with a lightbulb and blue line next to the related code segment
  - Implement functionality to undo/redo assessment-related inputs
  - Implement selection tool that allows to mark code segments for feedback with finger/Apple Pencil
  - Implement functionality to change the font size
  - Implement functionality to accept a feedback suggestion
  - Implement sheet that allows to give feedback consisting of a text and credits ranging from -10 to 10

    + Allow choosing from list of correction guidelines as templates for feedback
  - Show the current relative score of the assessed submission
  - Show an expandable correction sidebar that includes all assessment-related information

    + Show the problem statement with UML diagrams and test case information
    + Show the instructor's correction guidelines
    + Show all current feedbacks for this assessment (general, inline, automatic)

      * Implement functionality to give general feedbacks
      * Implement functionality to edit/delete inline/general feedbacks
      * Tapping on inline feedbacks results in showing the related code segment in the code editor
  - Implement functionality to save the current progress of an assessment
  - Implement functionality to submit the assessment
  - Implement functionality to dismiss the assessment
* Setup server for ML functionality
* Notify ML server when submitting assessments
* Store function blocks with related feedback in database
* Implement similarity comparison for function blocks of submissions with stored blocks in database
* Connect app to ML server