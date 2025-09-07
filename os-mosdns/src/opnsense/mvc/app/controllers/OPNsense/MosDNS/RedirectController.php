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
 * Class RedirectController
 * @package OPNsense\MosDNS
 */
class RedirectController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = 'OPNsense\MosDNS\MosDNS';

    public function searchRedirectAction()
    {
        return $this->searchBase('redirect.redirect', array('enabled', 'name', 'rules'));
    }

    public function getRedirectAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('redirect.redirect', 'redirect', $uuid);
    }

    public function addRedirectAction()
    {
        return $this->addBase('redirect.redirect', 'redirect');
    }

    public function delRedirectAction($uuid)
    {
        return $this->delBase('redirect.redirect', $uuid);
    }

    public function setRedirectAction($uuid)
    {
        return $this->setBase('redirect.redirect', 'redirect', $uuid);
    }

    public function toggleRedirectAction($uuid)
    {
        return $this->toggleBase('redirect.redirect', $uuid);
    }
}