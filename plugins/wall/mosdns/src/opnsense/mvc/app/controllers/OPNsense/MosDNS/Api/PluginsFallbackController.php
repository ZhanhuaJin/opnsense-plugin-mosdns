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

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

/**
 * Class PluginsFallbackController
 * @package OPNsense\MosDNS\Api
 */
class PluginsFallbackController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    // Fallback plugin methods
    public function searchFallbackAction()
    {
        $this->sessionClose();
        return $this->searchBase('plugins.fallback.fallback', array('enabled', 'name', 'primary', 'secondary', 'threshold', 'always_standby'), 'name');
    }

    public function getFallbackAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('fallback', 'plugins.fallback.fallback', $uuid);
    }

    public function setFallbackAction($uuid = null)
    {
        return $this->setBase('fallback', 'plugins.fallback.fallback', $uuid);
    }

    public function addFallbackAction()
    {
        return $this->addBase('fallback', 'plugins.fallback.fallback');
    }

    public function delFallbackAction($uuid = null)
    {
        return $this->delBase('plugins.fallback.fallback', $uuid);
    }

    public function toggleFallbackAction($uuid = null)
    {
        return $this->toggleBase('plugins.fallback.fallback', $uuid);
    }
}