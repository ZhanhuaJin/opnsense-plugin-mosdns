<?php

/**
 * Copyright (C) 2024 Deciso B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

function mosdns_enabled()
{
    global $config;
    return isset($config['OPNsense']['MosDNS']['general']['enabled']) &&
           $config['OPNsense']['MosDNS']['general']['enabled'] == '1';
}

function mosdns_services()
{
    $services = array();
    
    if (mosdns_enabled()) {
        $services[] = array(
            'description' => gettext('MosDNS DNS Forwarder'),
            'configd' => array(
                'restart' => array('mosdns restart'),
                'start' => array('mosdns start'),
                'stop' => array('mosdns stop'),
            ),
            'name' => 'mosdns',
            'pidfile' => '/var/run/mosdns.pid'
        );
    }
    
    return $services;
}

function mosdns_configure()
{
    return array(
        'bootup' => array('mosdns_configure_do'),
        'local' => array('mosdns_configure_do'),
        'newwanip' => array('mosdns_configure_do'),
    );
}

function mosdns_configure_do($verbose = false)
{
    global $config;
    
    if (mosdns_enabled()) {
        if ($verbose) {
            echo "Configuring MosDNS...\n";
        }
        
        // Generate configuration file
        configd_run('template reload OPNsense/MosDNS');
        
        // Restart service if it's running
        if (isvalidpid('/var/run/mosdns.pid')) {
            configd_run('mosdns restart');
        }
    }
}

function mosdns_xmlrpc_sync()
{
    $result = array();
    $result['id'] = 'mosdns';
    $result['section'] = 'OPNsense.MosDNS';
    $result['description'] = gettext('MosDNS DNS Forwarder');
    $result['services'] = array('mosdns');
    return array($result);
}