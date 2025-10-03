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

/**
 * Class GeneralController
 * @package OPNsense\MosDNS\Api
 */
class GeneralController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\\OPNsense\\MosDNS\\MosDNS';

    /**
     * Get general settings
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdlMosDNS = $this->getModel();
            $result['mosdns'] = $mdlMosDNS->getNodes();
        }
        return $result;
    }

    /**
     * Set general settings
     * @return array
     */
    public function setAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $mdlMosDNS = $this->getModel();
            $mdlMosDNS->setNodes($this->request->getPost("mosdns"));
            $valMsgs = $mdlMosDNS->performValidation();
            foreach ($valMsgs as $field => $msg) {
                $result["validations"]["mosdns." . $msg->getField()] = $msg->getMessage();
            }
            if (count($valMsgs) == 0) {
                $mdlMosDNS->serializeToConfig();
                $result["result"] = "saved";
            }
        }
        return $result;
    }

    /**
     * Reconfigure service
     * @return array
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

    /**
     * Get service status
     * @return array
     */
    public function statusAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns status");
            $result["status"] = trim($response);
        }
        return $result;
    }

    /**
     * Start service
     * @return array
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
     * Stop service
     * @return array
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
     * Restart service
     * @return array
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
}