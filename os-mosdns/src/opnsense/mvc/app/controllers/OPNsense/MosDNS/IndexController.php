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

use OPNsense\Base\ControllerBase;
use OPNsense\Core\Backend;

/**
 * Class IndexController
 * @package OPNsense\MosDNS
 */
class IndexController extends ControllerBase
{
    /**
     * Index page - General settings
     */
    public function indexAction()
    {
        $this->view->generalForm = $this->getForm("general");
        $this->view->pick('OPNsense/MosDNS/general');
    }

    /**
     * Plugins page
     */
    public function pluginsAction()
    {
        $this->view->pluginsForm = $this->getForm("plugins");
        $this->view->pick('OPNsense/MosDNS/plugins');
    }

    /**
     * Advanced page
     */
    public function advancedAction()
    {
        $this->view->advancedForm = $this->getForm("advanced");
        $this->view->pick('OPNsense/MosDNS/advanced');
    }

    /**
     * Statistics page
     */
    public function statisticsAction()
    {
        $this->view->pick('OPNsense/MosDNS/statistics');
    }

    /**
     * Logs page
     */
    public function logsAction()
    {
        $this->view->pick('OPNsense/MosDNS/logs');
    }

    /**
     * External Data page
     */
    public function externalDataAction()
    {
        $this->view->formDialogExternalData = $this->getForm("external_data");
        $this->view->pick('OPNsense/MosDNS/external_data');
    }

    /**
     * Cache plugin page
     */
    public function cacheAction()
    {
        $this->view->pick('OPNsense/MosDNS/cache');
    }

    /**
     * Forward plugin page
     */
    public function forwardAction()
    {
        $this->view->pick('OPNsense/MosDNS/forward');
    }

    /**
     * Redirect plugin page
     */
    public function redirectAction()
    {
        $this->view->pick('OPNsense/MosDNS/redirect');
    }

    /**
     * Hosts plugin page
     */
    public function hostsAction()
    {
        $this->view->pick('OPNsense/MosDNS/hosts');
    }

    /**
     * IPSet plugin page
     */
    public function ipsetAction()
    {
        $this->view->pick('OPNsense/MosDNS/ipset');
    }

    /**
     * Sequence plugin page
     */
    public function sequenceAction()
    {
        $this->view->pick('OPNsense/MosDNS/sequence');
    }

    /**
     * Fallback plugin page
     */
    public function fallbackAction()
    {
        $this->view->pick('OPNsense/MosDNS/fallback');
    }

    /**
     * Servers plugin page
     */
    public function serversAction()
    {
        $this->view->pick('OPNsense/MosDNS/servers');
    }

}