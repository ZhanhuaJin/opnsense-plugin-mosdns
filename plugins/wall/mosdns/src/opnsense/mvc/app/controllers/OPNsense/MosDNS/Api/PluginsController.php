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
 * Class PluginsController
 * @package OPNsense\MosDNS\Api
 * 
 * Note: This controller has been refactored. Plugin-specific methods have been moved to:
 * - PluginsForwardController.php (Forward plugin methods)
 * - PluginsRedirectController.php (Redirect plugin methods)
 * - PluginsHostsController.php (Hosts plugin methods)
 * - PluginsIpsetController.php (IPSet plugin methods)
 * - PluginsCacheController.php (Cache plugin methods)
 * - PluginsFallbackController.php (Fallback plugin methods)
 * - PluginsServersController.php (Servers plugin methods)
 */
class PluginsController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    // Forward plugin methods (delegated to PluginsForwardController)
    public function searchForwardAction()
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->searchForwardAction();
    }

    public function getForwardAction($uuid = null)
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->getForwardAction($uuid);
    }

    public function setForwardAction($uuid = null)
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->setForwardAction($uuid);
    }

    public function addForwardAction()
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->addForwardAction();
    }

    public function delForwardAction($uuid = null)
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->delForwardAction($uuid);
    }

    public function toggleForwardAction($uuid = null)
    {
        $forwardController = new \OPNsense\MosDNS\Api\PluginsForwardController();
        return $forwardController->toggleForwardAction($uuid);
    }

    // Redirect plugin methods (delegated to PluginsRedirectController)
    public function searchRedirectAction()
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->searchRedirectAction();
    }

    public function getRedirectAction($uuid = null)
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->getRedirectAction($uuid);
    }

    public function setRedirectAction($uuid = null)
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->setRedirectAction($uuid);
    }

    public function addRedirectAction()
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->addRedirectAction();
    }

    public function delRedirectAction($uuid = null)
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->delRedirectAction($uuid);
    }

    public function toggleRedirectAction($uuid = null)
    {
        $redirectController = new \OPNsense\MosDNS\Api\PluginsRedirectController();
        return $redirectController->toggleRedirectAction($uuid);
    }

    // Hosts plugin methods (delegated to PluginsHostsController)
    public function searchHostsAction()
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->searchHostsAction();
    }

    public function getHostsAction($uuid = null)
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->getHostsAction($uuid);
    }

    public function setHostsAction($uuid = null)
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->setHostsAction($uuid);
    }

    public function addHostsAction()
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->addHostsAction();
    }

    public function delHostsAction($uuid = null)
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->delHostsAction($uuid);
    }

    public function toggleHostsAction($uuid = null)
    {
        $hostsController = new \OPNsense\MosDNS\Api\PluginsHostsController();
        return $hostsController->toggleHostsAction($uuid);
    }

    // IPSet plugin methods (implemented directly)
    public function searchIPSetAction()
    {
        // Use the correct model path for IPSet
        return $this->searchBase('plugins.ipset.ipset', array('enabled', 'name', 'sets', 'description'), 'name');
    }

    public function getIPSetAction($uuid = null)
    {
        return $this->getBase('plugins.ipset.ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function setIPSetAction($uuid = null)
    {
        return $this->setBase('plugins.ipset.ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function addIPSetAction()
    {
        return $this->addBase('plugins.ipset.ipset', 'plugins.ipset.ipset');
    }

    public function delIPSetAction($uuid = null)
    {
        return $this->delBase('plugins.ipset.ipset', $uuid);
    }

    public function toggleIPSetAction($uuid = null)
    {
        return $this->toggleBase('plugins.ipset.ipset', $uuid);
    }

    // Cache plugin methods (delegated to PluginsCacheController)
    public function searchCacheAction()
    {
        $cacheController = new \OPNsense\MosDNS\Api\PluginsCacheController();
        return $cacheController->searchCacheAction();
    }

    public function getCacheAction($uuid = null)
    {
        $cacheController = new \OPNsense\MosDNS\Api\PluginsCacheController();
        return $cacheController->getCacheAction($uuid);
    }

    public function setCacheAction($uuid = null)
    {
        $cacheController = new \OPNsense\MosDNS\Api\PluginsCacheController();
        return $cacheController->setCacheAction($uuid);
    }

    // Fallback plugin methods (delegated to PluginsFallbackController)
    public function searchFallbackAction()
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->searchFallbackAction();
    }

    public function getFallbackAction($uuid = null)
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->getFallbackAction($uuid);
    }

    public function setFallbackAction($uuid = null)
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->setFallbackAction($uuid);
    }

    public function addFallbackAction()
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->addFallbackAction();
    }

    public function delFallbackAction($uuid = null)
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->delFallbackAction($uuid);
    }

    public function toggleFallbackAction($uuid = null)
    {
        $fallbackController = new \OPNsense\MosDNS\Api\PluginsFallbackController();
        return $fallbackController->toggleFallbackAction($uuid);
    }

    // Servers plugin methods (delegated to PluginsServersController)
    public function searchServersAction()
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->searchServersAction();
    }

    public function getServersAction($uuid = null)
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->getServersAction($uuid);
    }

    public function setServersAction($uuid = null)
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->setServersAction($uuid);
    }

    public function addServersAction()
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->addServersAction();
    }

    public function delServersAction($uuid = null)
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->delServersAction($uuid);
    }

    public function toggleServersAction($uuid = null)
    {
        $serversController = new \OPNsense\MosDNS\Api\PluginsServersController();
        return $serversController->toggleServersAction($uuid);
    }

    // Sequence plugin methods (delegated to PluginsSequenceController)
    public function searchSequenceAction()
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->searchSequenceAction();
    }

    public function getSequenceAction($uuid = null)
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->getSequenceAction($uuid);
    }

    public function setSequenceAction($uuid = null)
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->setSequenceAction($uuid);
    }

    public function addSequenceAction()
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->addSequenceAction();
    }

    public function delSequenceAction($uuid = null)
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->delSequenceAction($uuid);
    }

    public function toggleSequenceAction($uuid = null)
    {
        $sequenceController = new \OPNsense\MosDNS\Api\PluginsSequenceController();
        return $sequenceController->toggleSequenceAction($uuid);
    }

    // Rule plugin methods (delegated to PluginsRuleController)
    public function searchRuleAction()
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->searchRuleAction();
    }

    public function getRuleAction($uuid = null)
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->getRuleAction($uuid);
    }

    public function setRuleAction($uuid = null)
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->setRuleAction($uuid);
    }

    public function addRuleAction()
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->addRuleAction();
    }

    public function delRuleAction($uuid = null)
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->delRuleAction($uuid);
    }

    public function toggleRuleAction($uuid = null)
    {
        $ruleController = new \OPNsense\MosDNS\Api\PluginsRuleController();
        return $ruleController->toggleRuleAction($uuid);
    }
}