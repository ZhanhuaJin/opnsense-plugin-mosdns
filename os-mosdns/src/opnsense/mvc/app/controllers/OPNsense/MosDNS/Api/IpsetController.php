<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\PluginTypes;

class IpsetController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'plugintypes';
    protected static $internalModelClass = 'OPNsense\MosDNS\PluginTypes';
    protected static $internalModelUseSafeDelete = true;

    /**
     * Get ipset plugin configurations
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdl = $this->getModel();
            $result['ipset'] = $mdl->ipset->getNodes();
        }
        return $result;
    }

    /**
     * Get specific ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function getItemAction($uuid = null)
    {
        $mdl = $this->getModel();
        if ($uuid != null) {
            $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
            if ($node != null) {
                return array('ipset' => $node->getNodes());
            }
        }
        return array();
    }

    /**
     * Add new ipset plugin
     * @return array
     */
    public function addItemAction()
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            $node = $mdl->ipset->plugin->Add();
            $node->setNodes($this->request->getPost('ipset'));
            $valMsgs = $mdl->performValidation();
            if (count($valMsgs) == 0) {
                $mdl->serializeToConfig();
                $result['uuid'] = $node->getAttribute('uuid');
                $result['result'] = 'saved';
            } else {
                $result['validations'] = $valMsgs;
            }
        }
        return $result;
    }

    /**
     * Update ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function setItemAction($uuid)
    {
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
                if ($node != null) {
                    $node->setNodes($this->request->getPost('ipset'));
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        return array('result' => 'saved');
                    } else {
                        return array('result' => 'failed', 'validations' => $valMsgs);
                    }
                }
            }
        }
        return array('result' => 'failed');
    }

    /**
     * Delete ipset plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function delItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                if ($mdl->ipset->plugin->del($uuid)) {
                    $mdl->serializeToConfig();
                    $result['result'] = 'deleted';
                } else {
                    $result['result'] = 'not found';
                }
            }
        }
        return $result;
    }

    /**
     * Toggle ipset plugin enabled/disabled
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('ipset.plugin.' . $uuid);
                if ($node != null) {
                    if ($node->enabled->__toString() == '1') {
                        $node->enabled = '0';
                    } else {
                        $node->enabled = '1';
                    }
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        $result['result'] = 'saved';
                    } else {
                        $result['validations'] = $valMsgs;
                    }
                }
            }
        }
        return $result;
    }

    /**
     * Search ipset plugins
     * @return array
     */
    public function searchItemAction()
    {
        return $this->searchBase('ipset.plugin', array('enabled', 'tag', 'files'));
    }
}