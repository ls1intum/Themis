Deployment and Configuration
===========================================

.. Describe the steps an system administrator needs to take to install your system on the infrastructure described in the section above. If necessary explain any parameters like domains, IP addresses, ports, etc. within your system that need to be configured. This does not include details about the configuration of your infrastructure, which should already be described in the previous section.

~~~~~~~~~~~~~~~
CI/CD Pipeline
~~~~~~~~~~~~~~~

All changes on the develop branch are automatically deployed to TestFlight.

  * **Build and Release Pipeline:**
    
    This pipeline is automatically triggered by changes in the Themis repository. It checks for swiftlint errors. It uses 
    fastlane to build the app. If the change is on the develop branch then it releases to TestFlight.

~~~~~~~~~~~~~~~~~~~
TestFlight Release
~~~~~~~~~~~~~~~~~~~

TestFlight supports multiple user groups. In our case it is divided into Developers, Customer + Management and Tutors.
It offers two kinds of testers, namely internal (Developers and Customer + Management) and external testers (Tutors). The 
main difference is that interal testers are registered via their Apple-ID and external testers download the app anonymously 
via a public TestFlight link.

  * **Developers:**

    They are able to downloads all version of the app and can always install the newest version.

  * **Customer + Management and Tutors:**

    This group gets the newest release manually via adding a certain build to their group. Furthermore, it is possible to 
    release notes.
