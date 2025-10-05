<?php

/**
 *    Copyright (C) 2023 Deciso B.V.
 *
 *    All rights reserved.
 *
 *    Redistribution and use in source and binary forms, with or without
 *    modification, are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 *    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *    AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 *    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *    POSSIBILITY OF SUCH DAMAGE.
 *
 */

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;

/**
 * Class PluginsSequenceController
 * @package OPNsense\MosDNS
 */
class PluginsSequenceController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    /**
     * Search sequence plugins
     * @return array
     */
    public function searchSequenceAction()
    {
        $this->sessionClose();
        return $this->searchBase('plugins.sequence.sequence', array('enabled', 'name', 'exec'), 'name');
    }

    /**
     * Get sequence plugin details
     * @param string $uuid item unique id
     * @return array
     */
    public function getSequenceAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Update sequence plugin with given properties
     * @param string $uuid item unique id
     * @return array
     */
    public function setSequenceAction($uuid = null)
    {
        return $this->setBase('sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Add new sequence plugin and set with given properties
     * @return array
     */
    public function addSequenceAction()
    {
        return $this->addBase('sequence', 'plugins.sequence.sequence');
    }

    /**
     * Delete sequence plugin by uuid
     * @param string $uuid item unique id
     * @return array
     */
    public function delSequenceAction($uuid = null)
    {
        return $this->delBase('plugins.sequence.sequence', $uuid);
    }

    /**
     * Toggle sequence plugin by uuid (enable/disable)
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleSequenceAction($uuid = null)
    {
        return $this->toggleBase('plugins.sequence.sequence', $uuid);
    }
}