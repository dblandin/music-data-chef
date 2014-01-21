# Rails Application Chef Kitchen

Installs and configures the following services:

 - Ruby 2.0.0-p247
 - PostgreSQL Database Server
 - Redis Database
 - Nginx Web Server
 - Node.js (for asset compilation)

Sets up a deploy user, app database, and various files and directories needed
for the application.

The application is deployed and managed using Capistrano.

Sensitive values are stored in encrypted data bags.
