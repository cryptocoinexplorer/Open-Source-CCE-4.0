#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# utility.py
#
# Copyright 2015 Hartland PC LLC
#
# This file is part of the open source version of CCE 4.0.
#
# This package is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This package is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package.  If not, see <http://www.gnu.org/licenses/>.


import sys
import time
import ConfigParser
import re
import pymysql
from DBUtils.PooledDB import PooledDB
from decimal import *


# Configuration file reader
config_parse = ConfigParser.ConfigParser()
config_parse.read("cce.conf")
CONFIG = {section: {option: config_parse.get(section, option) for option in config_parse.options(section)} for section
          in config_parse.sections()}
URL = str('http://' + CONFIG["coind"]["rpcuser"] + ':' + CONFIG["coind"]["rpcpass"] + '@127.0.0.1:' + CONFIG["coind"][
    "rpcport"])

pool = PooledDB(pymysql, 50, db=CONFIG['database']['dbname'], host='127.0.0.1', port=3306,
                user=CONFIG['database']['dbuser'],
                passwd=CONFIG['database']['dbpassword'], use_unicode=True, charset="utf8",
                setsession=['SET AUTOCOMMIT = 1'])


def format_time(nTime):
    try:

        return time.strftime('%m-%d-%y | %H:%M:%S', time.gmtime(int(nTime)))
    except:
        return "???"


def format_hour(nTime):
    try:

        return time.strftime('%H:%M:%S', time.gmtime(int(nTime)))
    except:
        return "???"


def time_passed(nTime):
    try:
        seconds = int(time.time()) - nTime
        if seconds < 0:
            return str(abs(seconds)) + ' seconds in the future'
        elif seconds < 60:
            return str(seconds) + ' seconds'
        else:
            minutes = int(seconds / 60)
            if minutes == 1:
                seconds = int(seconds % 60)
                return str(minutes) + ' minute ' + str(seconds) + ' seconds'
            else:
                return str(minutes) + ' minutes'

        return format_hour(nTime)
    except:
        return format_hour(nTime)


def normalize(n):
    try:
        num = Decimal(n).normalize()
        return num.__trunc__() if not num % 1 else Decimal(num)
    except:
        return n


def query_single(sql, *parms):
    try:
        db = pool.connection(shareable=False)
        cur = db.cursor()
        cur.execute(sql, parms)
        ret = cur.fetchone()
        cur.close()
        db.close
        return ret
    except Exception as e:
        print >> sys.stderr, e, str('query_single: ' + sql)
        return None


def query_multi(sql, *parms):
    try:
        db = pool.connection(shareable=False)
        cur = db.cursor()
        cur.execute(sql, parms)
        ret = cur.fetchall()
        cur.close()
        db.close
        return ret
    except Exception as e:
        print >> sys.stderr, e, str('query_multi: ' + sql)
        return None


def query_noreturn(sql, *parms):
    try:
        db = pool.connection(shareable=False)
        cur = db.cursor()
        ret = cur.execute(sql, parms)
        cur.close()
        db.close
        return ret
    except Exception as e:
        print >> sys.stderr, e, str('query_noreturn: ' + sql)
        return None


def homepage():
    try:
        stats = query_single('SELECT * FROM stats')
        topblocks = query_multi('SELECT * FROM block ORDER BY height DESC LIMIT 10')
        return {'Status': 'ok', 'stats': stats, 'topblocks': topblocks}
    except Exception as e:
        print >> sys.stderr, e, 'Homepage'
        return {'Status': 'error', 'Data': 'Unknown error'}


def search_type(sterm):
    try:
        sterm = str(re.sub(r'[^a-zA-Z0-9]', '', sterm))
        if sterm.isdigit():
            ret = query_single('SELECT * FROM block WHERE height = %s', sterm)
        else:
            ret = query_single('SELECT * FROM block WHERE hash = %s', sterm)
        if ret is None:
            ret = query_single('SELECT * FROM tx_out WHERE tx_hash = %s', sterm)
            if ret is None:
                ret = query_single('SELECT * FROM address WHERE address = %s', sterm)
                if ret is None:
                    raise Exception
                else:
                    return {'Status': 'ok', 'Data': '/address?address=' + sterm}
            else:
                return {'Status': 'ok', 'Data': '/transaction?transaction=' + sterm}
        else:
            return {'Status': 'ok', 'Data': '/block?block=' + sterm}
    except:
        return {'Status': 'error', 'Data': 'Not Found'}


def get_block(block):
    try:
        if block == '-1':
            blk = query_single('SELECT * FROM block ORDER BY height DESC LIMIT %s', 1)
        elif str(block).isdigit():
            blk = query_single('SELECT * FROM block WHERE height = %s', block)
        else:
            block = str(re.sub(r'[^a-zA-Z0-9]', '', block))
            blk = query_single('SELECT * FROM block WHERE hash = %s', block)
        if blk is None:
            raise Exception
        ret = query_multi('SELECT tx_hash FROM tx_out WHERE height = %s', blk[0])
        if ret[0] is None:
            return {'Status': 'ok', 'blk': blk, 'tx': 'Not Found,'}
        else:
            ret = ret[::-1]
            tx = set(ret)
            return {'Status': 'ok', 'blk': blk, 'tx': tx, 'poschain':CONFIG['chain']['pos']}
    except:
        return {'Status': 'error', 'Data': 'Block not found'}


def get_transaction(transaction):
    try:
        transaction = str(re.sub(r'[^a-zA-Z0-9]', '', transaction))
        txin = query_multi('SELECT * FROM tx_in WHERE tx_hash = %s', transaction)
        txout = query_multi('SELECT * FROM tx_out WHERE tx_hash = %s', transaction)
        if txin is None or txout is None:
            return {'Status': 'error', 'Data': 'Transaction not found'}
        blk = query_single('SELECT * FROM block WHERE height = %s', txout[0][6])
        return {'Status': 'ok', 'blk': blk, 'txin': txin, 'txout': txout}
    except Exception as e:
        print >> sys.stderr, e, 'Transactions'
        return {'Status': 'error', 'Data': 'Unknown error'}


def get_peerinfo():
    try:
        peerinfo = query_multi('SELECT * FROM peers')
        if peerinfo is None:
            return {'Status': 'error', 'Data': 'Not Found'}
        else:
            return {'Status': 'ok', 'Data': peerinfo}

    except Exception as e:
        print >> sys.stderr, e, 'Peerinfo'
        return {'Status': 'error', 'Data': 'Unknown error'}


def get_rich():
    try:
        rich = query_multi('SELECT * FROM top_address ORDER BY rank ASC')
        if rich is None:
            return {'Status': 'error', 'Data': 'Not Found'}
        else:
            return {'Status': 'OK', 'Data': rich}

    except Exception as e:
        print >> sys.stderr, e, 'Rich List'
        return {'Status': 'error', 'Data': 'Unknown error'}

def get_largetx():
    try:
        largetx = query_multi('SELECT * FROM large_tx ORDER BY amount ASC')
        if largetx is None:
            return {'Status': 'error', 'Data': 'Not Found'}
        else:
            return {'Status': 'OK', 'Data': largetx}

    except Exception as e:
        print >> sys.stderr, e, 'Large TX'
        return {'Status': 'error', 'Data': 'Unknown error'}


def get_address(address):
    try:
        address = str(re.sub(r'[^a-zA-Z0-9]', '', address))
        balance = query_single('SELECT balance FROM address WHERE address = %s', address)
        if balance is None:
            return {'Status': 'error', 'Data': 'Unknown error'}
        txin = []
        txout = []
        retxin = query_multi('SELECT * FROM tx_in WHERE address = %s ORDER BY height DESC LIMIT 100', address)
        retxout = query_multi('SELECT * FROM tx_out WHERE address = %s ORDER BY height DESC LIMIT 100', address)
        if retxin:
            for row in retxin:
                txtime = format_time(int(query_single('SELECT time FROM block WHERE height = %s', row[8])[0]))
                txin += [[txtime, row[0], row[6]]]
        for row in retxout:
            txtime = format_time(int(query_single('SELECT time FROM block WHERE height = %s', row[6])[0]))
            txout += [[txtime, row[0], row[2]]]
        return {'Status': 'OK', 'balance': balance, 'txin': txin, 'txout': txout, 'address': address}

    except Exception as e:
        print >> sys.stderr, e, 'Address Page'
        return {'Status': 'error', 'Data': 'Unknown error'}