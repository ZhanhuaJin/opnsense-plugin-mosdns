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

use OPNsense\Base\ApiControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Core\Config;

/**
 * Class SettingsController
 * @package OPNsense\MosDNS\Api
 */
class SettingsController extends ApiControllerBase
{

    /**
     * Get all settings
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $config = Config::getInstance()->object();
            $mosdnsConfig = isset($config->proxy->mosdns) ? $config->proxy->mosdns : new \stdClass();
            $result['mosdns'] = $mosdnsConfig;
        }
        return $result;
    }

    /**
     * Set all settings
     * @return array
     */
    public function setAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $config = Config::getInstance()->object();
            $postData = $this->request->getPost("mosdns");
            
            // Ensure proxy section exists
            if (!isset($config->proxy)) {
                $config->proxy = new \stdClass();
            }
            
            // Save MosDNS configuration to proxy.mosdns
            $config->proxy->mosdns = $postData;
            
            // Save configuration
            Config::getInstance()->save();
            
            // Generate config.yaml from template
            $backend = new Backend();
            $backend->configdRun("template reload OPNsense/MosDNS");
            
            // Restart MosDNS service if enabled
            if (isset($postData["general"]["enabled"]) && 
                $postData["general"]["enabled"] == "1") {
                $backend->configdRun("mosdns restart");
            }
            
            $result["result"] = "saved";
        }
        return $result;
    }
}