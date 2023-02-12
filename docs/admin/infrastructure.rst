Infrastructure Setup
===========================================

.. Describe the setup of the infrastructure in terms of hardware, software and protocols so it can be configured by a system administrator at the client site. This include virtual machines, software packages etc. You can reuse the deployment diagram from the section Hardware/Software Mapping. Describe the installation and startup order for each component. You can reuse the use cases from the section Boundary Conditions. For example: If you have used docker reuse the Docker installation instructions from the cross project space.

*****
Themis App
*****

The app can be installed on iPads via `TestFlight`_. Therefore, it requires TestFlight to be installed on the iPad and the user
to be part of at least one group, either via Apple-ID or via public TestFlight link. The only formal requirement is iPadOS 16.

Apart from that, the iPad app can also be tested via XCode and its integrated Simulator. To prevent entering the Artemis 
credentials every time rebuilding the app while testing, just add them to your XCode environment variables. For that, click on
the Themis icon on the top and choose "Edit Scheme...". Under "Environment Variables", add ARTEMIS_STAGING_SERVER, 
ARTEMIS_STAGING_USER and ARTEMIS_STAGING_PASSWORD with their according values. To use the preview feature in XCode, wrap
your preview component with an AuthenticatedPreview.

For future maintenance, the existing CI/CD-Pipeline and the TestFlight account is needed.

*****
ThemisML
*****

The `ThemisML`_ system is installed on a VM which has Ubuntu 20.04 installed. The only software that has to be installed is
`Docker`_, as explained in `this`_ tutorial.

Furthermore, a TLS/SSL certificate is needed to ensure a secure connection with the client over HTTPS. This has to be set to
as defined in the ``docker-compose.production.yml``.

Lastly, Harbor, a registry for artifacts, needs to be configured. It stores the built docker images so that the server can
always pull the latest in case of a deployment.

.. links
.. _TestFlight: https://developer.apple.com/testflight/
.. _Themis: https://github.com/ls1intum/Themis-ML
.. _Docker: https://www.docker.com/
.. _this: https://docs.docker.com/engine/install/ubuntu/
.. _Harbor: https://harbor.ase.in.tum.de/