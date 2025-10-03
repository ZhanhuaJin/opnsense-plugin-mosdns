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

/**
 * Class StatisticsController
 * @package OPNsense\MosDNS\Api
 */
class StatisticsController extends ApiControllerBase
{
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
            $result["running"] = strpos($response, "running") !== false;
        }
        return $result;
    }

    /**
     * Get service statistics
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            // Get basic status
            $backend = new Backend();
            $status = $backend->configdRun("mosdns status");
            $result["status"] = trim($status);
            $result["running"] = strpos($status, "running") !== false;
            
            // Additional statistics can be added here
            $result["uptime"] = "N/A";
            $result["queries"] = "N/A";
            $result["cache_hits"] = "N/A";
        }
        return $result;
    }
}