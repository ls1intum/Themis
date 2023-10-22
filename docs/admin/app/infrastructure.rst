Infrastructure Setup
===========================================

.. Describe the setup of the infrastructure in terms of hardware, software and protocols so it can be configured by a
.. system administrator at the client site. This include virtual machines, software packages etc. You can reuse the
.. deployment diagram from the section Hardware/Software Mapping. Describe the installation and startup order for each
.. component. You can reuse the use cases from the section Boundary Conditions. For example: If you have used docker
.. reuse the Docker installation instructions from the cross project space.

Themis needs to connect to an Artemis server instance to operate. The deployment diagram below can be useful to
understand the infrastructure:

.. image:: /contributor/system/images/deployment_diagram.png

The app can be installed on iPads via `TestFlight`_. Therefore, it requires TestFlight to be installed on the iPad and the user
to be part of at least one group, either via Apple-ID or via public TestFlight link. The only formal requirement is iPadOS 17.

Apart from that, the iPad app can also be tested via XCode and its integrated Simulator. To prevent entering the Artemis 
credentials every time rebuilding the app while testing, just add them to your XCode environment variables. For that, click on
the Themis icon on the top and choose "Edit Scheme...". Under "Environment Variables", add ``ARTEMIS_STAGING_SERVER``, 
``ARTEMIS_STAGING_USER`` and ``ARTEMIS_STAGING_PASSWORD`` with their according values. To use the preview feature in XCode, wrap
your preview component with an ``AuthenticatedPreview``.

For future maintenance, the existing CI/CD-Pipeline and the TestFlight account is needed.

.. _TestFlight: https://testflight.apple.com/join/NmyhJo2V
