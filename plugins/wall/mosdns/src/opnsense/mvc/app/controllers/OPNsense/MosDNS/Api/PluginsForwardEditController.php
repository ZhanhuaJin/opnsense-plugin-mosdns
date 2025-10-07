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
 * Class PluginsForwardEditController
 * @package OPNsense\MosDNS\Api
 */
class PluginsForwardEditController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    // Upstream management methods for the edit page
    public function searchUpstreamAction()
    {
        return $this->searchBase('plugins.forward.forward.upstreams.upstream', array('addr', 'trusted', 'detour', 'domain', 'enable_http3'), 'addr');
    }

    public function getUpstreamAction($uuid = null)
    {
        return $this->getBase('upstream', 'plugins.forward.forward.upstreams.upstream', $uuid);
    }

    public function setUpstreamAction($uuid = null)
    {
        return $this->setBase('upstream', 'plugins.forward.forward.upstreams.upstream', $uuid);
    }

    public function addUpstreamAction()
    {
        return $this->addBase('upstream', 'plugins.forward.forward.upstreams.upstream');
    }

    public function delUpstreamAction($uuid = null)
    {
        return $this->delBase('plugins.forward.forward.upstreams.upstream', $uuid);
    }

    public function toggleUpstreamAction($uuid = null)
    {
        return $this->toggleBase('plugins.forward.forward.upstreams.upstream', $uuid);
    }
}