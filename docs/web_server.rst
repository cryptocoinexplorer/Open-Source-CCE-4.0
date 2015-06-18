========================
Web Server Documentation
========================

.. contents::

Module Description
------------------

* websrv.py
    The main module for the web server. Based on CherryPy runs as a daemon.
    Uses the Jinja2 HTML template system.

* serverutil.py
    The logic module for the web server. Handles most of the database interaction.

Configuration file (server.conf)
--------------------------------

::

    [/]
    tools.encode.on: True
    tools.gzip.on: True
    tools.gzip.mime_types: ['text/html', 'text/plain', 'application/json', 'text/javascript', 'application/javascript']
    tools.proxy.on: True
    tools.caching.on : True
    tools.caching.delay: 15

    [global]
    server.socket_port:8222
    engine.autoreload.on: False
    server.environment: 'production'
    request.show_tracebacks: False
    server.thread_pool: 30

* This is a basic CherryPy configuration file. Most of these settings will not need to be changed.
* If running multiple explorers, give each a unique port
* Please see CherryPy documentation for more details on these settings.

Setting up with Apache2 using http_proxy
----------------------------------------

* Enable the proxy_http mod.

        - sudo a2enmod proxy_http

* Virtual host file should be set up similar to this:

        - Generally located at:  /etc/apache2/sites-available/<configuration file>
        - The port number in ProxyPass and ProxyPassReverse need to match the port assigned in server.conf

::

        <VirtualHost         *:80>

            ServerName <Domain name>
            ServerAlias <Alternate Domain name>
            ProxyPreserveHost On
            ProxyErrorOverride On
            DocumentRoot /var/www/<Directory where static files are located>
            ProxyPass /image !
            ProxyPass /robots.txt !
            ProxyPass /css !
            ProxyPass /js !
            <Proxy *>
            Order allow,deny
            Allow from all
            </Proxy>
            ProxyPass / http://localhost:8222/
            ProxyPassReverse / http://localhost:8222/
        </VirtualHost>

* Install Bootstrap3 css and js files to their appropriate css and js directory in document root.

        - Alternately, find a host for bootstrap3 and change the base.html header to reflect.

* If using a favicon.ico and/or robots.txt, place the file(s) in document root.

* Give the Apache2 server ownership of the document root directory.

        - sudo chown -R www-data <path to document root>

* If this is a new configuration file, activate the virtual host.

        - The configuration file must have the extension: .conf

        - sudo a2ensite <name of the virtual host configuration file>

        - sudo service apache2 restart

* If adding to a current running virtual host, reload the configuration.

        - sudo service apache2 reload

Starting the web server
-----------------------

* Make sure the database loader is working correctly and the database is populated.

* Start the server with:

    - python websrv.py

Stopping the web server
-----------------------

* Run the kill.sh script





