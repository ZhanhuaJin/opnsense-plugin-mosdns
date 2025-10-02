<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\MosDNS;

class SequenceController extends ApiMutableModelControllerBase
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

    // IPSet plugin methods
    public function searchIpsetAction()
    {
        try {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.ipset.ipset');
            if ($node === null) {
                return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
            }
            return $this->searchBase('plugins.ipset.ipset', array('enabled', 'name', 'set_name', 'description'), 'name');
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getIpsetAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function setIpsetAction($uuid = null)
    {
        return $this->setBase('ipset', 'plugins.ipset.ipset', $uuid);
    }

    public function addIpsetAction()
    {
        return $this->addBase('ipset', 'plugins.ipset.ipset');
    }

    public function delIpsetAction($uuid = null)
    {
        return $this->delBase('plugins.ipset.ipset', $uuid);
    }

    public function toggleIpsetAction($uuid = null)
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
}