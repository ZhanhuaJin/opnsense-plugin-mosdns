<?php

/**
 * Copyright (C) 2023 Deciso B.V.
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

/**
 * Class PluginsController
 * @package OPNsense\MosDNS
 */
class PluginsController extends ControllerBase
{
    public function indexAction()
    {
        // Set page title for the plugins overview page
        $this->view->title = "MosDNS Plugins";
        
        // Load form definitions for dialog boxes
        $this->view->formDialogEditForward = $this->getForm("dialogForward");
        $this->view->formDialogEditRedirect = $this->getForm("dialogRedirect");
        $this->view->formDialogEditRules = $this->getForm("dialogRules");
        $this->view->formDialogEditHosts = $this->getForm("dialogHosts");
        $this->view->formDialogEditIPSet = $this->getForm("dialogIPSet");
        $this->view->formDialogEditSequence = $this->getForm("dialogSequence");
        $this->view->formDialogEditFallback = $this->getForm("dialogFallback");
        $this->view->formDialogEditServers = $this->getForm("dialogServers");
        $this->view->formDialogEditCache = $this->getForm("cache");
        
        // Generate grid configurations for tables
        $this->view->formGridForward = $this->getFormGrid('dialogForward');
        $this->view->formGridRedirect = $this->getFormGrid('dialogRedirect');
        $this->view->formGridRules = $this->getFormGrid('dialogRules');
        $this->view->formGridHosts = $this->getFormGrid('dialogHosts');
        $this->view->formGridIPSet = $this->getFormGrid('dialogIPSet');
        $this->view->formGridSequence = $this->getFormGrid('dialogSequence');
        $this->view->formGridFallback = $this->getFormGrid('dialogFallback');
        $this->view->formGridServers = $this->getFormGrid('dialogServers');
        $this->view->formGridCache = $this->getFormGrid('cache');
        
        $this->view->pick('OPNsense/MosDNS/plugins');
    }

    public function cacheAction()
    {
        $this->view->pick('OPNsense/MosDNS/cache');
    }

    public function forwardAction()
    {
        $this->view->pick('OPNsense/MosDNS/forward');
    }

    public function redirectAction()
    {
        $this->view->pick('OPNsense/MosDNS/redirect');
    }

    public function hostsAction()
    {
        $this->view->pick('OPNsense/MosDNS/hosts');
    }

    public function ipsetAction()
    {
        // Load form dialog for IPSet configuration
        $this->view->formDialogEditIPSet = $this->getForm("dialogIPSet");
        $this->view->pick('OPNsense/MosDNS/ipset');
    }

    public function sequenceAction()
    {
        $this->view->pick('OPNsense/MosDNS/sequence');
    }

    public function fallbackAction()
    {
        $this->view->pick('OPNsense/MosDNS/fallback');
    }

    public function serversAction()
    {
        $this->view->pick('OPNsense/MosDNS/servers');
    }
}