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

use OPNsense\Base\IndexController as BaseIndexController;
use OPNsense\Core\Backend;

/**
 * Class IndexController
 * @package OPNsense\MosDNS
 */
class IndexController extends BaseIndexController
{
    /**
     * Main index page with anchor-based navigation
     */
    public function indexAction()
    {
        // Set page title
        $this->view->title = "MosDNS";
        
        // Load forms for all tabs
        $this->view->generalForm = $this->getForm("MosDNS");
        
        // Use the main index view
        $this->view->pick('OPNsense/MosDNS/index');
    }

    /**
     * Legacy action redirects - for backward compatibility
     */
    public function pluginsAction()
    {
        return $this->response->redirect('/ui/mosdns/#plugins');
    }

    public function advancedAction()
    {
        return $this->response->redirect('/ui/mosdns/#advanced');
    }

    public function statisticsAction()
    {
        return $this->response->redirect('/ui/mosdns/#statistics');
    }

    public function logsAction()
    {
        return $this->response->redirect('/ui/mosdns/#logs');
    }

    public function cacheAction()
    {
        return $this->response->redirect('/ui/mosdns/#cache');
    }

    public function forwardAction()
    {
        return $this->response->redirect('/ui/mosdns/#forward');
    }

    public function redirectAction()
    {
        return $this->response->redirect('/ui/mosdns/#redirect');
    }

    public function hostsAction()
    {
        return $this->response->redirect('/ui/mosdns/#hosts');
    }

    public function ipsetAction()
    {
        return $this->response->redirect('/ui/mosdns/#ipset');
    }

    public function sequenceAction()
    {
        return $this->response->redirect('/ui/mosdns/#sequence');
    }

    public function fallbackAction()
    {
        return $this->response->redirect('/ui/mosdns/#fallback');
    }

    public function serversAction()
    {
        return $this->response->redirect('/ui/mosdns/#servers');
    }



}