.. _themisml-deployment:
Deployment and Configuration
===========================================

.. Describe the steps an system administrator needs to take to install your system on the infrastructure described in the section above. If necessary explain any parameters like domains, IP addresses, ports, etc. within your system that need to be configured. This does not include details about the configuration of your infrastructure, which should already be described in the previous section.

~~~~~~~~~~~~~~~~
CI/CD Pipelines
~~~~~~~~~~~~~~~~

ThemisML is deployed via two subsequent CI/CD-Pipelines.

  * **Build and Delivery Pipeline:**

    This pipeline is automatically triggered by changes in the ThemisML repository. It builds a docker image of the 
    feedback-suggestion service with the ``docker-compose.production.yml`` and pushes it to Harbor, the used artifactory.

  * **Deploy Pipeline:**

    This pipeline is manually triggered if a new software version shall be deployed to the server. It connects to the server 
    via SSH and copies securely the ``docker-compose.production.yml`` file and all files defined in it, especially including 
    the traefik configuration files. After that it logs in to Harbor and pulls the docker image. In the end it starts all the 
    docker containers including the feedback-suggestion service, traefik and the PostgreSQL database.

~~~~~~~~~~~~~~~~~~
Domains and ports
~~~~~~~~~~~~~~~~~~

Traefik listens on the URL `https://ios2223cit.ase.cit.tum.de/ <https://ios2223cit.ase.cit.tum.de/>`_ on the ports 80 (HTTP) and 443 (HTTPS). However, it
redirects all incoming traffic from port 80 to port 443 to ensure a secured connection. For the HTTPS connection, it
uses a SSL/TLS certificate from the TUM Rechnerbetriebsgruppe.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Manual Restart of the ThemisML Server:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  * **Stopping and removing all running containers:**
  
    ``docker compose -f docker-compose.production.yml down``

  * **Alternatively stopping all running containers:**
    
    ``docker compose -f docker-compose.production.yml stop``

  * **Starting all containers:**
    
    ``docker compose -f docker-compose.production.yml up -d``
