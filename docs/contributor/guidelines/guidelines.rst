****************************
Coding and Design Guidelines
****************************

.. contents:: Contents
    :local:
    :depth: 1


Folder Structure
===========================================
The app is located under ``/Themis`` and the main folders are:

* **Models** - structs that encapsulate the app's data
* **Views** - structs that are responsible for building the user interface
* **ViewModels** - classes that are observed by views and control what is shown to the user
* **Services** - structs that make API calls
* **Extensions** - structs that extend the behavior of various types
* **Styles** - view modifiers, button styles and other style-related reusable elements

User Interface (UI)
===========================================
General
-------
* Adhere to the Model-View-ViewModel (MVVM) pattern
* Do not implement business logic in Views. Move it to the ViewModels instead.

Design Language
---------------
When making UI changes, it's crucial to maintain a delicate equilibrium between the design aesthetics
of Artemis and Apple. The objective is to create a user-friendly system by keeping UI elements
consistent with Artemis and simultaneously adhering to
`Apple's Human Interface Guidelines <https://developer.apple.com/design/human-interface-guidelines>`_.

Symbols
-------
Prioritize SF Symbols in your design choices, and resort to custom assets sparingly, using them only
when it is really necessary.

Loading State
-------------
Usually, JSON data is decoded into arrays of model elements. In such cases, use the ``.mock(if:)`` function in combination
with ``.showsSkeleton(if:)`` view modifier to generate mock data while the actual data is loading and show a skeleton animation
to convey the loading state to the user. If you are not satisfied with the effect of ``.showsSkeleton(if:)``, you can
create custom skeleton (placeholder) views and present them using the ``shows(_ skeletonView: , if:)`` view modifier.

Reuse
===========================================
Always keep in mind that any functionality or UI element that will be shared between Artemis iOS clients should be
implemented in the `ArtemisCore <https://github.com/ls1intum/artemis-ios-core-modules>`_ package.
