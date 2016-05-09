In this folder there is a Dockerfile for building a MySQL image which addresses the userid conflict between Mac and Linux (when using Docker in a Vagrant machine hosted on Mac OSX).

When creating a MySQL container, use this custom image and not the default one

The import.sql file allows to create a employee and a customer table in the sample database, both with one record. It must be used only once, the first time that a MySQL container is created.
