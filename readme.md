## Base for scaffolding a basic Laravel project

## REQUERIMENTS:
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Python](https://www.python.org/)
* [Fabric](http://www.fabfile.org/)
* [fabutils](https://github.com/vinco/fabutils)


## Setup the virtual machine
* `$ vagrant up`
* `$ fab environment:vagrant bootstrap`
* `fab environment:vagrant bootstrap`
* Add virtualhost to host machine `192.168.33.11   laravel.local`
* Visit `http://laravel.local`


## MySql Database in vagrant environment
* `User`: `root`
* `Password`: `password`
* `Name`: `laravel`


## Make migrations
* `fab environment:<environment> makemigration:<migrationname>`


## Migrate database
* `fab environment:<environment> migrate`


## Database seed
* `fab environment:<environment> dbseed`


## Deploy to server
*  `fab environment:<environment> deploy:<branch_name>`
