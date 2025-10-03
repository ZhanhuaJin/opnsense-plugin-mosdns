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
 */
class PluginsController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    // Forward plugin methods
    public function searchForwardAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.forward.forward');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.forward.forward', array('enabled', 'name', 'upstream', 'concurrent', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getForwardAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function setForwardAction($uuid = null)
    {
        return $this->setBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function addForwardAction()
    {
        return $this->addBase('forward', 'plugins.forward.forward');
    }

    public function delForwardAction($uuid = null)
    {
        return $this->delBase('plugins.forward.forward', $uuid);
    }

    public function toggleForwardAction($uuid = null)
    {
        return $this->toggleBase('plugins.forward.forward', $uuid);
    }

    // Redirect plugin methods
    public function searchRedirectAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.redirect.redirect');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.redirect.redirect', array('enabled', 'name', 'target', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getRedirectAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('redirect', 'plugins.redirect.redirect', $uuid);
    }

    public function setRedirectAction($uuid = null)
    {
        return $this->setBase('redirect', 'plugins.redirect.redirect', $uuid);
    }

    public function addRedirectAction()
    {
        return $this->addBase('redirect', 'plugins.redirect.redirect');
    }

    public function delRedirectAction($uuid = null)
    {
        return $this->delBase('plugins.redirect.redirect', $uuid);
    }

    public function toggleRedirectAction($uuid = null)
    {
        return $this->toggleBase('plugins.redirect.redirect', $uuid);
    }

    // Rules plugin API endpoints (for backward compatibility)
    public function searchRulesAction()
    {
        // Rules are now part of sequences, redirect to sequence rules
        return $this->searchRuleAction();
    }

    public function getRulesAction($uuid = null)
    {
        // Rules are now part of sequences, this method is deprecated
        return array('result' => 'failed', 'message' => 'Rules are now part of sequences');
    }

    public function addRulesAction()
    {
        // Rules are now part of sequences, this method is deprecated
        return array('result' => 'failed', 'message' => 'Rules are now part of sequences');
    }

    public function delRulesAction($uuid = null)
    {
        // Rules are now part of sequences, this method is deprecated
        return array('result' => 'failed', 'message' => 'Rules are now part of sequences');
    }

    public function setRulesAction($uuid = null)
    {
        // Rules are now part of sequences, this method is deprecated
        return array('result' => 'failed', 'message' => 'Rules are now part of sequences');
    }

    public function toggleRulesAction($uuid = null)
    {
        // Rules are now part of sequences, this method is deprecated
        return array('result' => 'failed', 'message' => 'Rules are now part of sequences');
    }

    // Hosts plugin methods
    public function searchHostsAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.hosts.hosts');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.hosts.hosts', array('enabled', 'name', 'hosts_file', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getHostsAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('hosts', 'plugins.hosts.hosts', $uuid);
    }

    public function setHostsAction($uuid = null)
    {
        return $this->setBase('hosts', 'plugins.hosts.hosts', $uuid);
    }

    public function addHostsAction()
    {
        return $this->addBase('hosts', 'plugins.hosts.hosts');
    }

    public function delHostsAction($uuid = null)
    {
        return $this->delBase('plugins.hosts.hosts', $uuid);
    }

    public function toggleHostsAction($uuid = null)
    {
        return $this->toggleBase('plugins.hosts.hosts', $uuid);
    }



    /**
     * Search sequences
     * @return array
     */
    public function searchSequenceAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.sequence.sequence');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.sequence.sequence', array('enabled', 'name', 'tag', 'type', 'args', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    /**
     * Get sequence by UUID
     * @param string $uuid sequence UUID
     * @return array
     */
    public function getSequenceAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Set sequence properties
     * @param string $uuid sequence UUID
     * @return array
     */
    public function setSequenceAction($uuid = null)
    {
        return $this->setBase('sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Add new sequence
     * @return array
     */
    public function addSequenceAction()
    {
        return $this->addBase('sequence', 'plugins.sequence.sequence');
    }

    /**
     * Delete sequence
     * @param string $uuid sequence UUID
     * @return array
     */
    public function delSequenceAction($uuid = null)
    {
        return $this->delBase('plugins.sequence.sequence', $uuid);
    }

    /**
     * Toggle sequence enabled state
     * @param string $uuid sequence UUID
     * @return array
     */
    public function toggleSequenceAction($uuid = null)
    {
        return $this->toggleBase('plugins.sequence.sequence', $uuid);
    }

    /**
     * Search sequence rules
     * @param string $sequence_uuid parent sequence UUID
     * @return array
     */
    public function searchRuleAction($sequence_uuid = null)
    {
        if (empty($sequence_uuid)) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
        
        $mdl = $this->getModel();
        $sequence = $mdl->getNodeByReference('plugins.sequence.sequence.' . $sequence_uuid);
        if ($sequence == null) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
        
        return $this->searchBase('plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule', 
                                array('enabled', 'name', 'tag', 'type', 'args', 'description'), 'name');
    }

    /**
     * Get sequence rule by UUID
     * @param string $sequence_uuid parent sequence UUID
     * @param string $uuid rule UUID
     * @return array
     */
    public function getRuleAction($sequence_uuid = null, $uuid = null)
    {
        $this->sessionClose();
        if (empty($sequence_uuid)) {
            return array();
        }
        return $this->getBase('rule', 'plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule', $uuid);
    }

    /**
     * Set sequence rule properties
     * @param string $sequence_uuid parent sequence UUID
     * @param string $uuid rule UUID
     * @return array
     */
    public function setRuleAction($sequence_uuid = null, $uuid = null)
    {
        if (empty($sequence_uuid)) {
            return array('result' => 'failed', 'validations' => array());
        }
        return $this->setBase('rule', 'plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule', $uuid);
    }

    /**
     * Add new sequence rule
     * @param string $sequence_uuid parent sequence UUID
     * @return array
     */
    public function addRuleAction($sequence_uuid = null)
    {
        if (empty($sequence_uuid)) {
            return array('result' => 'failed');
        }
        return $this->addBase('rule', 'plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule');
    }

    /**
     * Delete sequence rule
     * @param string $sequence_uuid parent sequence UUID
     * @param string $uuid rule UUID
     * @return array
     */
    public function delRuleAction($sequence_uuid = null, $uuid = null)
    {
        if (empty($sequence_uuid)) {
            return array('result' => 'failed');
        }
        return $this->delBase('plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule', $uuid);
    }

    /**
     * Toggle sequence rule enabled state
     * @param string $sequence_uuid parent sequence UUID
     * @param string $uuid rule UUID
     * @return array
     */
    public function toggleRuleAction($sequence_uuid = null, $uuid = null)
    {
        if (empty($sequence_uuid)) {
            return array('result' => 'failed');
        }
        return $this->toggleBase('plugins.sequence.sequence.' . $sequence_uuid . '.rules.rule', $uuid);
    }

    // IPSet plugin methods
    public function searchIPSetAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.ipset.ipset');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.ipset.ipset', array('enabled', 'name', 'set_name', 'sets', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getIPSetAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function setIPSetAction($uuid = null)
    {
        return $this->setBase('ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function addIPSetAction()
    {
        return $this->addBase('ipset', 'plugins.ipset.ipset');
    }

    public function delIPSetAction($uuid = null)
    {
        return $this->delBase('plugins.ipset.ipset', $uuid);
    }

    public function toggleIPSetAction($uuid = null)
    {
        return $this->toggleBase('plugins.ipset.ipset', $uuid);
    }

    // Fallback plugin methods
    public function searchFallbackAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.fallback.fallback');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.fallback.fallback', array('enabled', 'name', 'primary', 'secondary', 'threshold', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getFallbackAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('fallback', 'plugins.fallback.fallback', $uuid);
    }

    public function setFallbackAction($uuid = null)
    {
        return $this->setBase('fallback', 'plugins.fallback.fallback', $uuid);
    }

    public function addFallbackAction()
    {
        return $this->addBase('fallback', 'plugins.fallback.fallback');
    }

    public function delFallbackAction($uuid = null)
    {
        return $this->delBase('plugins.fallback.fallback', $uuid);
    }

    public function toggleFallbackAction($uuid = null)
    {
        return $this->toggleBase('plugins.fallback.fallback', $uuid);
    }

    // Servers plugin methods
    public function searchServersAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.servers.servers');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.servers.servers', array('enabled', 'name', 'entry', 'listen', 'udp_or_tcp', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getServersAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('servers', 'plugins.servers.servers', $uuid);
    }

    public function setServersAction($uuid = null)
    {
        return $this->setBase('servers', 'plugins.servers.servers', $uuid);
    }

    public function addServersAction()
    {
        return $this->addBase('servers', 'plugins.servers.servers');
    }

    public function delServersAction($uuid = null)
    {
        return $this->delBase('plugins.servers.servers', $uuid);
    }

    public function toggleServersAction($uuid = null)
    {
        return $this->toggleBase('plugins.servers.servers', $uuid);
    }

    // Cache plugin API endpoints (single instance, not ArrayField)
    public function searchCacheAction()
    {
        // Cache is not an ArrayField, so we need to return it as a single item
        $model = $this->getModel();
        $cache = $model->plugins->cache;
        
        return array(
            'rows' => array(
                array(
                    'uuid' => 'cache-singleton',
                    'enabled' => (string)$cache->enabled,
                    'size' => (string)$cache->size,
                    'lazy_cache_ttl' => (string)$cache->lazy_cache_ttl
                )
            ),
            'rowCount' => 1,
            'total' => 1,
            'current' => 1
        );
    }

    public function getCacheAction($uuid = null)
    {
        $model = $this->getModel();
        $cache = $model->plugins->cache;
        
        return array(
            'cache' => array(
                'enabled' => (string)$cache->enabled,
                'size' => (string)$cache->size,
                'lazy_cache_ttl' => (string)$cache->lazy_cache_ttl
            )
        );
    }

    public function setCacheAction($uuid = null)
    {
        return $this->setBase('plugins.cache', 'plugins.cache', $uuid);
    }
}