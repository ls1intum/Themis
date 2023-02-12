Visionary Scenarios
===========================================

In the following, the requirements of the Themis app are explained by means of visionary scenarios. The presented three scenarios describe the most important functionality that was developed and contain the following actors: 

| Anna: Tutor in the iPraktikum’s intro course
| Tim: Tutor in the lecture-based course Patterns in Software Engineering
| 

**Scenario 1: Inspect student submissions for programming exercises**
| 

Anna is asked by a student, why the latest submission does not pass a specific automatic test. Anna opens the app on her iPad and navigates to the latest submission of the student. On the left of the screen a file tree of all the files in the student’s repository is displayed. Anna taps on the first file. The app opens the file and displays the source code in the editor alongside the file tree. The editor also supports syntax highlighting, which helps Anna to understand the code and how it is structured quickly. Anna does not find any issues in the first file, so she taps on the next file in the file tree and the corresponding source code is displayed in the editor view. In this file, Anna notices that the student returns the wrong value inside a function. The student can easily correct the mistake and submit again.

| 

**Scenario 2: Assess student submissions by giving (inline) feedback**
| 

Tim is assigned for correcting the programming exercises of the Patterns in Software Engineering exam. He opens the app and navigates to one of the exam’s programming exercises. The app shows details about the specific exercise such as its task description and statistics indicating how many submissions still need to be assessed. As the currently selected exercise still has submissions that are not assessed yet, Tim taps on a button stating Assess next submission.
| 

As a result, the app opens one of the unassessed student submission in its editor view. Tim looks through the student’s code and identifies that the wrong software pattern was implemented for the task. Therefore, he uses his stylus to input an individual, handwritten feedback for the student, which the application immediately transforms to text. Tim also assigns a score reduction of three points to this general feedback.
| 

Tim wants to give inline feedback to a specific code segment. He simply selects the lines of codes he wants to give feedback for. The editor then visually indicates the selected code segment and also provides a popup allowing Tim to enter the feedback and corresponding score reduction. Tim has no more feedback to give to the current submission, so he taps on the submit button.

|

**Scenario 3: Provide automatic feedback suggestions**
|

Anna want’s to assess the latest available homework submission. She opens the app, navigates to the first homework exercise. Besides the exercise task description, the app also displays a button to assess the next submission, which Anna taps. The app loads the corresponding submission and displays the file tree. A feedback icon is shown next to some of the filenames. This indicates that automatic feedback suggestions are available for these files. Anna taps on the first file appended with such an icon and the corresponding source code is shown in the editor. Additionally, some of the code segments are highlighted to indicate the existence for automatic feedback suggestions. Anna taps on the first suggestions and the app opens a popup showing the proposed feedback. Anna reads the feedback and concludes that it is also suitable for the current student’s code segment, so she taps a button to use the feedback as well.


