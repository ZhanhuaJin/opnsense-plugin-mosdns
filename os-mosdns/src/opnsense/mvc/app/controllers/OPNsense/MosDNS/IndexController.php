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

use OPNsense\Base\IndexController;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

/**
 * Class IndexController
 * @package OPNsense\MosDNS
 */
class IndexController extends IndexController
{
    /**
     * Index page
     */
    public function indexAction()
    {
        $this->view->generalForm = $this->getForm("general");
        $this->view->upstreamsForm = $this->getForm("upstreams");
        $this->view->pluginsForm = $this->getForm("plugins");
        $this->view->advancedForm = $this->getForm("advanced");
        $this->view->pick('OPNsense/MosDNS/index');
    }

    /**
     * Get configuration data
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdlMosDNS = new MosDNS();
            $result['mosdns'] = $mdlMosDNS->getNodes();
        }
        return $result;
    }

    /**
     * Set configuration data
     */
    public function setAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $mdlMosDNS = new MosDNS();
            $mdlMosDNS->setNodes($this->request->getPost("mosdns"));
            $valMsgs = $mdlMosDNS->performValidation();
            foreach ($valMsgs as $field => $msg) {
                if (!array_key_exists("validations", $result)) {
                    $result["validations"] = array();
                }
                $result["validations"]["mosdns." . $msg->getField()] = $msg->getMessage();
            }
            if ($valMsgs->count() == 0) {
                $mdlMosDNS->serializeToConfig();
                $this->saveConfig();
                $result["result"] = "saved";
            }
        }
        return $result;
    }

    /**
     * Start MosDNS service
     */
    public function startAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns start");
            $result["result"] = trim($response) == "OK" ? "started" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Stop MosDNS service
     */
    public function stopAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns stop");
            $result["result"] = trim($response) == "OK" ? "stopped" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Restart MosDNS service
     */
    public function restartAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns restart");
            $result["result"] = trim($response) == "OK" ? "restarted" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Get service status
     */
    public function statusAction()
    {
        $backend = new Backend();
        $response = $backend->configdRun("mosdns status");
        return array("status" => trim($response));
    }

    /**
     * Get service logs
     */
    public function logAction()
    {
        $backend = new Backend();
        $response = $backend->configdRun("mosdns log");
        return array("log" => $response);
    }

    /**
     * Reconfigure service
     */
    public function reconfigureAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("template reload OPNsense/MosDNS");
            if (trim($response) == "OK") {
                $response = $backend->configdRun("mosdns restart");
                $result["result"] = trim($response) == "OK" ? "reconfigured" : "failed";
            }
            $result["response"] = $response;
        }
        return $result;
    }
}