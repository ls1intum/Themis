Product Backlog
===========================================
* Create App Icon/Name
* Implement REST API for Communication with Artemis
* Implement Authentication Functionality for Artemis Users
  
  - use Bearer Token / Cookie based Authentication based on Artemis Version
* Implement a Functionality to view and switch between the Tutors Courses
* Implement a View that shows all Exercises for a Course and allows selecting them

  - Show a Timeline indicating Release-, Submission- and Assesment (Due) Dates
* Implement a View that shows Assessment Statistics for a specific Exercise
* Implement a Functionality to search for a specific Students Submission
* Implement a Functionality to open a Submission in Read-Only-Mode
* Implement a Functionality to start the Assessment of a randomly assigned Submission
* Implement a Functionality to continue the Assessment of a previously saved/submitted Assessment
* Implement an AssessmentView that is used for the Assessment Workflow

  - Show an expandable FileTree of the Submissions Repository that allows selecting Files
  - Show all opened Files as dismissable/rearrangable Tabs above the Code Editor
  - Show the Source Code of the selected File in a Code Editor
  
    + Apply dynamic Syntax Highlighting based on the File Extension
    + Show the Students Changes as a Diff
    + Highlight all Code-specific inline Feedbacks
    + Toggle Feedback Edit-Mode when clicking on inline Highlight
    + Indicate available Feedback Suggestions with a Lightbulb and blue Line next to the related Code Segment
  - Implement a Functionality to undo/redo Assessment-related Inputs
  - Implement a Selection Tool that allows to mark Code Segments for Feedback with Finger/Apple Pencil
  - Implement a Functionality to change the Font Size
  - Implement a Functionality to accept a Feedback Suggestion
  - Implement a Sheet that allows to give Feedback consisting of a Text and Credits ranging from -10 to 10
  
    + Allow choosing from List of Correction Guidelines as Templates for Feedback
  - Show the current relative Score of the assessed Submission
  - Show an expandable Correction Sidebar that includes all Assessment-related Information
  
    + Show the problem statement with UML Diagrams and Test Case Information
    + Show the Instructors Correction Guidelines
    + Show all current Feedbacks for this Assessment (general, inline, automatic)
      
      * Implement a Functionality to give general Feedbacks
      * Implement a Functionality to edit/delete inline/general Feedbacks
      * Tapping on inline Feedbacks results in showing the related Code Segment in the Code Editor
  - Implement a Functionality to save the current Progress of an Assessment
  - Implement a Functionality to submit the Assessment
  - Implement a Functionality to dismiss the Assessment
* Setup Server for ML Functionality
* Notify ML Server when Submitting Assessments
* Store Function Blocks with related Feedback in Database
* Implement Similarity Comparison for Function Blocks of Submissions with stored Blocks in Database
* Connect App to ML Server