User Interface
===========================================

.. something in general about the ui
The user interface of Themis is designed to be as intuitive as possible. The main goal is to provide a simple and easy to use interface for tutors to assess programming exercises.

Initial Mockups
***************

The high-fidelity mockups below show the initial design draft for Themis. They focus on the assessment view and display the main
workflow using the iPad app. The view is mainly divided into three parts horizontally, including a file tree sidebar,
the code viewer as well as a correction sidebar (from left to right). Within the code viewer, tutors can highlight
specific lines of code and provide feedback. After finishing the assessment, the tutor can submit the feedback and
either jump to the next submission or stop assessing.

+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/mockup_assessment.png               |  .. figure:: ../images/mockup_feedback.png                     |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Assessment view (highlighted code)*                    |       *Assessment view (feedback)*                             |
+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/mockup_submit.png                   |  .. figure:: ../images/mockup_next-action.png                  |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Assessment view (submit)*                              |       *Assessment view (next action)*                          |
+-----------------------------------------------------------+----------------------------------------------------------------+


Current Design
**************

The current design is shown below. Starting with the course view, the tutor sees all exercises a course contains as
well as the corresponding information. Within each exercise, general statistics about the exercise are provided alongside
with the open submissions. While assessing, the tutor can give feedback using correction guidelines. An overview of all
feedback is listed in the correction sidebar (right side). Before finishing the assessment, the tutor can either save or
submit the current feedback.


+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/design_course.png                   |  .. figure:: ../images/design_exercise.png                     |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Course view*                                           |       *Exercise view*                                          |
+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/design_assessment.png               |  .. figure:: ../images/design_feedback.png                     |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Assessment view*                                       |       *Assessment view (feedback)*                             |
+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/design_guidelines.png               |  .. figure:: ../images/design_feedback-list.png                |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Assessment view (correction guidelines)*               |       *Assessment view (feedback overview)*                    |
+-----------------------------------------------------------+----------------------------------------------------------------+
| .. figure:: ../images/design_save.png                     |  .. figure:: ../images/design_submit.png                       |
|   :alt: Deployment diagram of Themis                      |       :alt: Deployment diagram of Themis                       |
|   :width: 450                                             |       :width: 450                                              |
|   :align: center                                          |       :align: center                                           |
|                                                           |                                                                |
|   *Assessment view (save)*                                |       *Assessment view (submit)*                               |
+-----------------------------------------------------------+----------------------------------------------------------------+
