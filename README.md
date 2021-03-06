# Continuous integration service for PostgreSQL

This is a collection of deployment and configuration pieces to set up
a continuous integration service running Jenkins for PostgreSQL.  I'm
running it at <http://pgci.eisentraut.org/>, but you can fork it and
run your own (or contribute to mine).

## Installation

Installation is currently supported on Debian wheezy (7) and Ubuntu precise (12.04 LTS).

`librarian-puppet` is used to manage Puppet modules.  Run

    gem install librarian-puppet

to install it.

On a fresh installation, clone the repository to `/srv/pgci`
(this exact path is currently required; I'm working on a way to avoid
that), and run

    librarian-puppet install
    puppet apply --modulepath=modules/ manifests/pgci.pp

If the Jenkins configuration is changed while Jenkins is running, you
need to go into Jenkins and choose "reload configuration from disk".

The Jenkins jobs are configured using
[Jenkins Job Builder](http://docs.openstack.org/infra/jenkins-job-builder/index.html)
using the definitions in the `job-builder/` directory.

## Local installation

For testing and development, use Vagrant and just call

    vagrant up

This will create a virtual machine with Jenkins running on port 50080
on the host.

## Manual setup

Some pieces should be set up manually:

- `dpkg-reconfigure icinga-cgi` for the `icingaadmin` password
- `/etc/aliases`, to get system email
- Jenkins users and authentication
- cron job from `tools/crontab` if desired
