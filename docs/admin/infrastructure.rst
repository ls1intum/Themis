Infrastructure Setup
===========================================

..Describe the setup of the infrastructure in terms of hardware, software and protocols so it can be configured by a system administrator at the client site. This include virtual machines, software packages etc. You can reuse the deployment diagram from the section Hardware/Software Mapping. Describe the installation and startup order for each component. You can reuse the use cases from the section Boundary Conditions. For example: If you have used docker reuse the Docker installation instructions from the cross project space.

*****
Themis App
*****

The app can be installed on iPads via TestFlight. Therefore, it requires TestFlight to be installed on the iPad and the user
to be part of at least one group, either via Apple-ID or via public TestFlight link.

Apart from that, the iPad app can also be tested with XCode and its integrated Simulator.

For future maintenance, the existing CI/CD-Pipeline and TestFlight account is needed.

*****
ThemisML
*****

Harbor is an artifactory that stores all docker images.