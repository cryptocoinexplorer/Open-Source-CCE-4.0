=============================
Database Loader Documentation
=============================

.. contents::

Module Description
------------------

* dbloader.py
    The main module for loading the database. It can be run from the
    command line or called by the coin daemon.

* comm.py
    The communication functions for both database and coin daemon RPC.
    It is not written to be run independently.

* stats.py
    Records statistics in the database that are stored every time the
    database loader is run rather then every block. These types of statistics
    are not tied to a block and generally cannot be retrieved from the
    coin daemon relative to the time they were queried from the daemon.
    For example: network hash rate. This module can be run independently.

DBloader start options
----------------------
* -v Verbose mode
    The dbloader will send various operating messages to stderr. If verbose
    is not specified, dbloader will run silently. Regardless of this setting,
    dbloader will record errors in the appropriate module logs.

* -n New database mode
    This option is to be used when starting a new coin database. The
    database must exist and be pre-formatted with the database structure
    in newdb.sql. The configuration file, cce.conf, must also be populated
    with the correct parameters.
    This mode creates the genesis block in the database without any transactions.
    if desired, the genesis block transactions will need to be put into the
    database manually.
    Cowtime,the timeout function for the main loop, will be set at 24 hours
    instead of the normal 5 minutes.
    After 101 blocks have been processed, the initial large_tx table is calculated.
    Large_tx will then be checked and updated every time a transaction is parsed.
    If the dbloader gets interrupted before the first 101 blocks, truncate the
    database and run dbloader with new database option again.
    If this happens after the first 101 blocks, run with the -l option instead.

* -l Long cowtime
    This will extend cowtime to 24 hours. Useful if a new database load
    gets interrupted after processing the first 101 blocks.

* -r Recheck mode
    Recheck mode treats the last 5 blocks in the database as if they
    are orphans and re-parses them. This mode does not record these blocks
    as orphans in the database.


Multiple options are allowed. Verbose mode can be combined with any other option(s).
Long and New will not effect each other as they both set cowtime to 24 hours.

Configuration file (cce.conf)
-----------------------------
* [database]
    - dbname:
            - Name of the coin database.
    - dbuser:
            - User name for access to the database.
    - dbpassword:
            - Password for access to the database.

* [coind]
    - rpcuser:
            - Coin daemon RPC user name
    - rpcpass:
            - Coin daemon RPC password
    - rpcport:
            - Coin daemon RPC port

* [chain]
    - name:
            - Coin chain name
    - pos:
            - Boolean indicating if the coin chain is proof of stake.

* [loader]
    - blockcheck: (Suggested: 250)
                    - Number of blocks back to check for orphans when the loader is called.
    - stats: (Suggested: true)
                    - Boolean indicating if the statistics module is to be run.
    - truncwarn: (Suggested: ignore)
                    - Value to use for PyMySQL warnings filter. Decimal is set to 30, 12 in the database.
                    - Since decimal types can cause unnecessary truncation warnings, ignore is the suggested setting.
                    - To have PyMySQL warnings go to the default stderr, set this to 'always'.

* [stat]
    - richlistlen: (Suggested: 1000)
                    - Number ranks to maintain for the rich list.
    - hashrate:
                    - Boolean indicating if the network hash is available by the daemon.
                    - Network hash rate can only be obtained from the coin daemon.
    - hashfield: (Suggested: networkhashps)
                    - Label of the field network hash rate is returned by the coin daemon.
    - ratelabel: (Suggested: MH or GH)
                    - Label to use for the hash rate on the index web page.
    - hashmult:
                - Hash rate multiplier to use for storing hash rate at desired level.
                - Example: Daemon output is 5678 H/s. Use the multipler 0.001 to store as 5.678.
    - mint:
                - How the total coins minted is retrieved.
                - calc  = calculate from database account balances. Mintfield will not be used.
                - daemon = get value from the coin daemon. Use with mintfield.

    - mintfield: (Suggested: moneysupply)
                - Label of total coins minted field returned by the daemon.

Coin daemon configuration
-------------------------

The coin daemon must be run with the following options in its .conf file
::

    daemon=1
    rpcuser=<username>
    rpcpassword=<password>
    txindex=1

If txindex is added after the coin daemon has started the block chain download,
it is generally required to run the daemon once with the --reindex option.

The 'blocknotify' option also needs to be set. It is recommended to add this option after
the coin daemon is synced and the database has been populated by the dbloader using the -n option.
::

    blocknotify=<path to the dbloaders 'coin.sh' file>

Be sure to put the correct directory to dbloader in the 'coin.sh' file


Auto start after a server reboot (Optional)
-------------------------------------------

Login the user account the coin daemon/dbloader is run under.

Run the command
::

    crontab -e

Add the following line to the Crontab.
::

    @reboot $HOME/.profile; $HOME/start.sh



Make sure to place the correct paths in 'start.sh' and place 'start.sh' in the user home directory.

Fast server note
----------------
When creating a new database, there can be issue with the urllib3 Python module which affects the requests module .
In a situation where the database loader is running extremely fast, the system may exhaust the max number of open TCP connections.
This is due to urllib3 always keeping connections open for recycle with no option to turn off recycling.
In normal server operations , this is generally not an issue as these open connections will auto close in 60 seconds.
However, in situations where the sever is very fast, the number of connections will eventually overtake
the maximum number of connections. In this situation lower the tcp_fin_timeout (/proc/sys/net/ipv4/tcp_fin_timeout)
to a value around 20.

