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

namespace OPNsense\MosDNS;

use OPNsense\Base\ApiMutableModelControllerBase;

/**
 * Class HostsController
 * @package OPNsense\MosDNS
 */
class HostsController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchHostsAction()
    {
        return $this->searchBase('hosts.hosts', array('enabled', 'name', 'files'));
    }

    public function getHostsAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('hosts.hosts', 'hosts', $uuid);
    }

    public function addHostsAction()
    {
        return $this->addBase('hosts.hosts', 'hosts');
    }

    public function delHostsAction($uuid)
    {
        return $this->delBase('hosts.hosts', $uuid);
    }

    public function setHostsAction($uuid)
    {
        return $this->setBase('hosts.hosts', 'hosts', $uuid);
    }

    public function toggleHostsAction($uuid)
    {
        return $this->toggleBase('hosts.hosts', $uuid);
    }
}