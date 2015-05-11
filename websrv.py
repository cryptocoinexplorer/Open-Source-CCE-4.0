#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# websrv.py
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

import os
import cherrypy
import jinja2
import simplejson as json
from cherrypy.process.plugins import Daemonizer
from cherrypy.process.plugins import PIDFile
from serverutil import *

# Set up log and pid file. Run the server as a daemon.
pid = str(os.getcwd() + "/cherrypy.pid")
log = str(os.getcwd() + "/server.log")
Daemonizer(cherrypy.engine, stderr=log).subscribe()
PIDFile(cherrypy.engine, pid).subscribe()

# Set up jinja2 environment and filters that point to functions in serverutil.py.
templateLoader = jinja2.FileSystemLoader(searchpath=str(os.getcwd() + '/html/'))
templateEnv = jinja2.Environment(loader=templateLoader)
templateEnv.filters['format_time'] = format_time
templateEnv.filters['format_hour'] = format_hour
templateEnv.filters['time_passed'] = time_passed
templateEnv.filters['normalize'] = normalize


class explorer:
    @cherrypy.expose
    def index(self, **args):
        try:
            ret = homepage()
            stats = ret.get('stats', None)
            topblocks = ret.get('topblocks', None)
            template = templateEnv.get_template('index.html')
            templateVars = {
                'stats': stats,
                'topblocks': topblocks,
                'name': CONFIG['chain']['name'],
                'ratelabel': CONFIG['stat']['ratelabel'],
            }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Homepage'
            raise cherrypy.HTTPError(503)



    @cherrypy.expose
    def block(self, **args):
        try:
            if args:
                arg = args.get('block', '-1')
                blk = get_block(arg)
            else:
                blk = get_block('-1')
            template = templateEnv.get_template('block.html')
            templateVars = {
                "block": blk,
                "name": CONFIG['chain']['name']
            }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Block page'
            raise cherrypy.HTTPError(503)

    @cherrypy.expose
    def search(self, **args):
        stype = search_type(args['sterm'])
        if stype['Status'] == 'ok':
            raise cherrypy.HTTPRedirect(stype['Data'])
        else:
            template = templateEnv.get_template('search.html')
            templateVars = {
                'name': CONFIG['chain']['name']
                    }
            return template.render(templateVars)

    @cherrypy.expose
    def peers(self, **args):
        try:
            peerinfo = get_peerinfo()
            template = templateEnv.get_template('peers.html')
            templateVars = {
                    'peerinfo': peerinfo,
                    'name': CONFIG['chain']['name']
                        }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Peer page'
            raise cherrypy.HTTPError(503)

    @cherrypy.expose
    def rich(self, **args):
        try:
            rich = get_rich()
            template = templateEnv.get_template('rich.html')
            templateVars = {
                    'rich': rich,
                    'name': CONFIG['chain']['name']
                        }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Rich page'
            raise cherrypy.HTTPError(503)

    @cherrypy.expose
    def transaction(self, **args):
        try:
            transaction = get_transaction(args['transaction'])
            template = templateEnv.get_template('transaction.html')
            templateVars = {
                    'transaction': transaction,
                    'name': CONFIG['chain']['name']
                        }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Transaction page'
            raise cherrypy.HTTPError(503)


    @cherrypy.expose
    def address(self, **args):
        try:
            address = get_address(args['address'])
            template = templateEnv.get_template('address.html')
            templateVars = {
                    'address': address,
                    'name': CONFIG['chain']['name']
                        }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Address page'
            raise cherrypy.HTTPError(503)

    @cherrypy.expose
    def largetx(self, **args):
        try:
            largetx = get_largetx()
            template = templateEnv.get_template('largetx.html')
            templateVars = {
                    'largetx': largetx,
                    'name': CONFIG['chain']['name']
                        }
            return template.render(templateVars)
        except Exception as e:
            print >> sys.stderr, e , 'Large TX page'
            raise cherrypy.HTTPError(503)

    # Explorer API. Simple commands are queried directly. More complex returns should use functions coded into serverutil.py.
    @cherrypy.expose
    def api(self, command, **args):
        try:
            if command == 'difficulty':
                diff_q = query_single('SELECT curr_diff FROM stats')
                difficulty = {'difficulty': diff_q[0]}
                return json.dumps(difficulty)
            elif command == 'totalmint':
                total_m = query_single('SELECT total_mint FROM stats')
                minted = {'total minted': total_m[0]}
                return json.dumps(minted)
            return json.dumps({'error':'invalid'})
        except Exception:
            raise cherrypy.HTTPError(503)

if __name__ == '__main__':
    cherrypy.quickstart(root=explorer(), config="server.conf")