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
 * Class ForwardController
 * @package OPNsense\MosDNS
 */
class ForwardController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchForwardAction()
    {
        return $this->searchBase('forward.forward', array('enabled', 'name', 'concurrent', 'upstreams'));
    }

    public function getForwardAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('forward.forward', 'forward', $uuid);
    }

    public function addForwardAction()
    {
        return $this->addBase('forward.forward', 'forward');
    }

    public function delForwardAction($uuid)
    {
        return $this->delBase('forward.forward', $uuid);
    }

    public function setForwardAction($uuid)
    {
        return $this->setBase('forward.forward', 'forward', $uuid);
    }

    public function toggleForwardAction($uuid)
    {
        return $this->toggleBase('forward.forward', $uuid);
    }
}