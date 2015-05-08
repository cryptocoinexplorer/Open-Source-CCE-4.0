#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# comm.py
#
# Copyright 2015 Hartland PC LLC
#
# This file is part of the open source version of CCE 4.0.
#

# This file is part of the open source version of the database loader for CCE 4.0.
#
# comm.py is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# comm.py is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with comm.py.  If not, see <http://www.gnu.org/licenses/>.

import os
import time
import ConfigParser
import simplejson as json
import logging
import requests
from interruptingcow import timeout

# Configuration file reader
config_parse = ConfigParser.ConfigParser()
config_parse.read("cce.conf")
CONFIG = {section: {option: config_parse.get(section, option) for option in config_parse.options(section)} for section
          in config_parse.sections()}
from warnings import filterwarnings
import pymysql
filterwarnings(CONFIG['loader']['truncwarn'],category=pymysql.Warning)

# Setup RPC URL and database connection
URL = str('http://' + CONFIG["coind"]["rpcuser"] + ':' + CONFIG["coind"]["rpcpass"] + '@127.0.0.1:' + CONFIG["coind"][
    "rpcport"])
conn = pymysql.connect(db=CONFIG["database"]["dbname"], host='127.0.0.1', port=3306, user=CONFIG["database"]["dbuser"],
                       passwd=CONFIG["database"]["dbpassword"])


# Error Logging
def comm_error_log(msg, function_name='No function name provided'):
    currtime = time.strftime('%m-%d %H:%M:%S', time.gmtime())
    logging.basicConfig(filename=str(os.getcwd() + "/comm.log"), level=logging.WARN)
    logging.error(currtime + ' ' + str(msg) + ' : ' + str(function_name))

# Daemon RPC 
def jsonrpc(method, *params):
    try:
        headers = {'content-type': 'application/json'}
        payload = json.dumps({"method": method, 'params': params, 'jsonrpc': '2.0'})
        # Cowtime for daemon RPC response set to 10 seconds
        with timeout(10, exception=Exception('Connection Timeout')):
            response = requests.get(URL, headers=headers, data=payload)
            if response.status_code != requests.codes.ok:
                return {'Status': 'error', 'Data': response.status_code}

        if response.json()['error']:
            return {'Status': 'error', 'Data': response.json()['error']}
        return {'Status': "ok", "Data": (response.json()['result'])}
    except Exception as e:
        comm_error_log(e, 'jsonrpc')
        return {'Status': 'error', 'Data': e}


# Next three functions are database query
def query_single(sql, *params):
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        ret = cur.fetchone()
        cur.close()
        return ret
    except Exception as e:
        comm_error_log(e, 'query single')
        return None


def query_multi(sql, *params):
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        ret = cur.fetchall()
        cur.close()
        return ret
    except Exception as e:
        comm_error_log(e, 'query multi')
        return None


def query_noreturn(sql, *params):
    try:
        cur = conn.cursor()
        ret = cur.execute(sql, params)
        cur.close()
        return ret
    except Exception as e:
        comm_error_log(e, 'query no return')
        comm_error_log(sql, 'query no return')
        return None
