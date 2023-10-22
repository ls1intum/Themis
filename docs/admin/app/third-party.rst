Third-party Components
===========================================

Introduction
------------

The Themis iPad App utilizes a number of open-source libraries to enhance its functionality and provide a seamless user experience. 
This provides an overview of the libraries used in the Themis iPad App.

ArtemisCore
-----------
The ArtemisCore library contains components that are common to all Artemis-related iOS clients.
Themis depends on this library for authentication, service layer calls, models, and some shared UI elements.

Library repository: https://github.com/ls1intum/artemis-ios-core-modules

KeychainAccess
--------------

The KeychainAccess library is used to securely store and retrieve sensitive information, 
such as authentication tokens. 
KeychainAccess provides a simple and secure way to store data in the iOS Keychain.

Library repository: https://github.com/kishikawakatsumi/KeychainAccess (master branch)

CodeEditor
----------

The CodeEditor library is a customizable and extensible code editor component for SwiftUI. The 
library is used in the Themis iPad App to provide a code editor for the user to read Code.
It was modified locally in order to support inline feedback. It is also reused for performing
text exercise assessments.

Library repository: https://github.com/ZeeZide/CodeEditor.git (locally modified)

SwiftUIReorderableForEach
-------------------------

The SwiftUIReorderableForEach library is used to create reorderable lists in SwiftUI. 
This library is used in the Themis iPad App to provide the user with the ability to reorder the Tabs for open Code-Files.

Library repository: https://github.com/globulus/swiftui-reorderable-foreach (main branch)

SwiftUI-Shimmer
-------------------------
SwiftUI-Shimmer is used for the implementation of skeleton loading. Views that are shown as
placeholders while loading content are animated using this library.

Library repository: https://github.com/markiv/SwiftUI-Shimmer