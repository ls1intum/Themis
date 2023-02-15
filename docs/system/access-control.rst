Access Control and Security
===========================================

.. Access control and security describes the user model of the system in terms of an access matrix. This section also describes security issues, such as the selection of an authentication mechanism, the use of encryption, and the management of keys. This section is optional. It should be included if the non-functional requirements include security concerns. For details refer to section 7.4.3 in Prof. Bruegge's book.

*****
Themis App
*****

In order to make requests to the Artemis server the user has to be authenticated, i.e. has to have a cookie which contains a jwt token. The corresponding cookie is set by the Artemis server when calling the `/authenticate`_ route. In iOS cookies are stored and managed in the `HTTPCookieStorage`_, which means no further management of the token is done by Themis.

*****
ThemisML
*****

When notifying or requesting feedback suggestions from ThemisML, the request has to contain the jwt token for Artemis of the requesting user. ThemisML only uses the token to make requests to the Artemis server and does not store the token.

.. _/authenticate: https://github.com/ls1intum/Artemis/blob/27e17c9066baba83b7750dc583de996c43ef94c7/src/main/java/de/tum/in/www1/artemis/web/rest/UserJWTController.java#L61-L85
.. _/HTTPCookieStorage: https://developer.apple.com/documentation/foundation/httpcookiestorage